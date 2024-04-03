import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/resources/style.dart';
import '../../../../data/sources/api/post_service.dart';
import '../../../../domain/entities/photo.dart';
import '../../../../domain/entities/post.dart';
import '../../../widgets/marker_painter.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  final Post post;
  final _mapController = Completer<GoogleMapController>();
  final _polylines = <Polyline>{};
  final _markers = <Marker>{};
  final _photos = <Photo>[];
  late final LatLngBounds _boundingBox;

  MapCubit(this.post) : super(const MapState()) {
    _processMap();
  }

  Future<void> _processMap() async {
    final service = PostService();
    final mapData = await service.fetchPostMap(post.id);
    if(mapData == null) return;
    _photos.addAll(mapData.photos);

    double topMost = -double.maxFinite;
    double rightMost = -double.maxFinite;
    double bottomMost = double.maxFinite;
    double leftMost = double.maxFinite;

    final geoPoints = mapData.coordinates.map((c) {
      topMost = math.max(topMost, c.latitude);
      rightMost = math.max(rightMost, c.longitude);
      bottomMost = math.min(bottomMost, c.latitude);
      leftMost = math.min(leftMost, c.longitude);
      return LatLng(c.latitude, c.longitude);
    }).toList(growable: false);

    _polylines.add(Polyline(
      polylineId: const PolylineId("route"),
      points: geoPoints,
      width: 4,
      color: AppStyle.primaryColor,
    ));

    emit(MapState(
      polylines: _polylines,
      markers: _markers,
      photos: _photos,
    ));
    final controller = await _mapController.future;
    await Future.delayed(const Duration(seconds: 1));
    _boundingBox = LatLngBounds(
      northeast: LatLng(topMost, rightMost),
      southwest: LatLng(bottomMost, leftMost),
    );
    controller.animateCamera(CameraUpdate.newLatLngBounds(_boundingBox, 80.0));

    final futures = <Future<void>>[];
    for(var p in mapData.photos) {
      futures.add(_buildMarker(p));
    }
    await Future.wait<void>(futures);
    emit(state.copyWith());
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }

  Future<void> _buildMarker(Photo photo) async {
    final bytes = (await NetworkAssetBundle(Uri.parse(photo.photoUrl))
        .load(photo.photoUrl)).buffer.asUint8List();
    final markerBytes = await MarkerPainter.getMarkerBytes(bytes);
    _markers.add(Marker(
      markerId: MarkerId(photo.id),
      position: LatLng(photo.latitude, photo.longitude),
      icon: BitmapDescriptor.fromBytes(markerBytes),
      onTap: () => emit(state.copyWith(photoTapped: photo)),
    ));
  }

  Future<void> viewRouteTaken() async {
    final controller = await _mapController.future;
    await controller.animateCamera(CameraUpdate.newLatLngBounds(_boundingBox, 80.0));
  }

  void toggleMarkersVisible() {
    if(state.markersVisible) {
      return emit(state.copyWith(
        markers: const {},
        markersVisible: false,
      ));
    }
    emit(state.copyWith(
      markers: _markers,
      markersVisible: true,
    ));
  }

  Future<void> showPhotoLocation(Photo photo) async {
    final controller = await _mapController.future;
    await controller.animateCamera(
      CameraUpdate.newLatLng(LatLng(photo.latitude, photo.longitude))
    );
  }

  @override
  Future<void> close() async {
    if(_mapController.isCompleted) {
      (await _mapController.future).dispose();
    }
    return super.close();
  }
}

// Set<Polyline> definePolylines(List<Coordinate> coordinates) {
//     int lineWidth = 5;
//     Set<Polyline> polylines = {};
//     List<LatLng> points = [];
//     if (coordinates.first.activityItem == ActivityItem.unknown) {
//       points = coordinates.map((c) => LatLng(c.latitude, c.longitude)).toList();
//       polylines.add(Polyline(
//         polylineId: PolylineId(coordinates.last.id),
//         points: points,
//         color: ActivityCategory.lineColors[ActivityItem.unknown]!,
//         width: lineWidth,
//       ));
//       return polylines;
//     }
//     var temp = coordinates.first;
//     for (var c in coordinates) {
//       if (c.activityItem == temp.activityItem) {
//         points.add(LatLng(c.latitude, c.longitude));
//       } else {
//         polylines.add(Polyline(
//           polylineId: PolylineId(temp.id),
//           points: points,
//           color: ActivityCategory.lineColors[temp.activityItem]!,
//           width: lineWidth,
//         ));
//         points = [];
//         temp = c;
//       }
//     }
//     return polylines;
//   }
