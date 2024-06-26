import "dart:io" as io;
import "dart:math" as math;
import "dart:ui";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import "package:nominatim_flutter/model/request/request.dart";
import "package:nominatim_flutter/nominatim_flutter.dart";

import "../../../../core/enum/social.dart";
import "../../../../core/services/location_service.dart";
import "../../../../core/utilities/image.dart";
import "../../../../core/utilities/utils.dart";
import "../../../../data/sources/api/post_service.dart";
import "../../../../domain/entities/coordinate.dart";
import "../../../../domain/entities/post.dart";
import "../../bloc/activity_tracking_bloc.dart";

part "saving_state.dart";

class SavingCubit extends Cubit<SavingState> {
  final TrackingResult _result;
  var _isProcessing = false;

  SavingCubit(this._result) : super(const SavingLoading()) {
    _processMapHelper();
  }
  
  void selectPostPrivacy(PostPrivacy value) {
    emit((state as SavingLoaded).copyWith(
      privacy: value,
    ));
  }

  Future<void> _processMap() async {
    final mapController = await _result.controller.future;
    await mapController
        .moveCamera(CameraUpdate.newLatLngBounds(_result.latLngBounds, 0.0));
    final screenSize = window.physicalSize;
    final deviceRatio = window.devicePixelRatio;
    final expectedHeight = screenSize.width / 2;
    final topRight = await mapController
        .getScreenCoordinate(_result.latLngBounds.northeast);
    final bottomLeft = await mapController
        .getScreenCoordinate(_result.latLngBounds.southwest);
    final distance = bottomLeft.y - topRight.y;
    var zoomLevel = await mapController.getZoomLevel();
    if(distance > expectedHeight) {
      final worldWidth = math.pow(2, zoomLevel) * 256;
      final newWorldWidth = expectedHeight * worldWidth / distance;
      zoomLevel = math.log(newWorldWidth / 256) / math.log(2);
    }
    await mapController
        .moveCamera(CameraUpdate.zoomTo(math.min(zoomLevel-2, 16)));
    await Future.delayed(const Duration(seconds: 3));
  }

  Future<void> _processMapHelper() async {
    await _processMap();
    final mapController = await _result.controller.future;
    final mapBytes = await mapController.takeSnapshot();
    final editedBytes = ImageUtils.editMapImage(mapBytes!);
    final fileName = ImageUtils.generateImageName();
    final file = await MyUtils.getAppTempFile(fileName);
    file.writeAsBytesSync(editedBytes);
    final dateTime = _result.record.endDate;
    emit(SavingLoaded(
      map: file,
      titleHint: "${MyUtils.getPartOfDay(dateTime)} run",
      titleController: TextEditingController(),
      contentController: TextEditingController(),
    ));
  }

  Future<void> savePost() async {
    if(_isProcessing) return;
    _isProcessing = true;
    final curtState = (state as SavingLoaded).copyWith(isProcessing: true);
    emit(curtState);
    try {
      final record = _result.record
      ..coordinates = _result.geoPoints
          .map((e) => Coordinate(latitude: e.latitude, longitude: e.longitude))
          .toList(growable: false);
      final position = await LocationService().getCurrentPosition();
      final reverseRequest = ReverseRequest(
        lat: position!.latitude,
        lon: position.longitude,
        extraTags: false,
        nameDetails: false,
      );
      final reverseResult = await NominatimFlutter.instance.reverse(
        reverseRequest: reverseRequest,
        language: "en-US, en",
      );
      final addressDetails = reverseResult.address!;
      final newPost = Post.empty()
      ..title = curtState.titleController.text.isEmpty 
          ? curtState.titleHint 
          : curtState.titleController.text
      ..content = curtState.contentController.text
      ..privacy = curtState.privacy
      ..record = record
      ..latitude = position.latitude
      ..longitude = position.longitude
      ..address = "${addressDetails["city"]}, ${addressDetails["country"]}";

      final service = PostService();
      final createdPost = await service.createPost(newPost);
      if (createdPost == null) {
        emit(curtState.copyWith(snackMsg: "Oops, something went wrong!"));
        return;
      }
      await service.uploadPostFiles(
        postId: createdPost.id, 
        params: _result.photosParams, 
        mapPath: curtState.map.path,
      );
      emit(const SavingSuccess());
      _isProcessing = false;
    } catch (e) {
      print(e);
      emit(curtState.copyWith(snackMsg: "Oops, something went wrong!"));
    }
  }

  @override
  Future<void> close() async {
    super.close();
    final curtState = state;
    if(curtState is SavingLoaded) {
      curtState.map.deleteSync();
    }
  }
}