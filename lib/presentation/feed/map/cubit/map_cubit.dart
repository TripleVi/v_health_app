import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/resources/colors.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../domain/entities/photo.dart';
import '../../../../domain/entities/post.dart';
import '../../../../domain/usecases/feed/map/get_map_details.dart';
import '../../../activity_tracking/widgets/marker_painter.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  final Post post;
  final _mapController = Completer<GoogleMapController>();
  final _polylines = <Polyline>{};
  final _markers = <Marker>{};
  List<Photo> photos = [];
  
  late final LatLngBounds _boundingBox;

  MapCubit(this.post) : super(const MapSuccess()) {
    _processMap();
  }

  Future<void> viewRouteTaken() async {
    final controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newLatLngBounds(_boundingBox, 24));
  }

  Future<void> _processMap() async {
    // final useCase = GetIt.instance<GetMapDetailsUseCase>();
    // final mapData = await useCase(params: _postId);
    // photos = mapData.photos;

    // double topMost = -double.maxFinite;
    // double rightMost = -double.maxFinite;
    // double bottomMost = double.maxFinite;
    // double leftMost = double.maxFinite;

    // final geoPoints = mapData.coordinates.map((c) {
    //   topMost = math.max(topMost, c.latitude);
    //   rightMost = math.max(rightMost, c.longitude);
    //   bottomMost = math.min(bottomMost, c.latitude);
    //   leftMost = math.min(leftMost, c.longitude);
    //   return LatLng(c.latitude, c.longitude);
    // }).toList(growable: false);

    // _polylines.add(Polyline(
    //   polylineId: const PolylineId("route"),
    //   points: geoPoints,
    //   width: 4,
    //   color: AppColor.primaryColor,
    // ));

    // final futures = <Future<void>>[];
    // for(var p in mapData.photos) {
    //   futures.add(_buildMarker(p));
    // }
    // await Future.wait<void>(futures);
    // emit(MapSuccess(
    //   polylines: _polylines,
    //   markers: _markers,
    //   photos: photos
    // ));

    // final controller = await _mapController.future;
    // _boundingBox = LatLngBounds(
    //   northeast: LatLng(topMost, rightMost),
    //   southwest: LatLng(bottomMost, leftMost),
    // );
    // controller.animateCamera(CameraUpdate.newLatLngBounds(_boundingBox, 24));
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }

  Future<void> _buildMarker(Photo photo) async {
    // final path = StorageService.join(_username, photo.name);
    // final bytes = await StorageService.downloadFileBytes(path);
    // if(bytes == null) return;
    // final markerBytes = await MarkerPainter.getMarkerBytes(bytes);
    // _markers.add(Marker(
    //   markerId: MarkerId(photo.name),
    //   position: LatLng(photo.latitude, photo.longitude),
    //   icon: BitmapDescriptor.fromBytes(markerBytes),
    //   onTap: () {},
    // ));
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

  // Future<List<Coordinate>> getData() async {
  //   final db = await SqlService.instance.database;
  //   final maps = await db.query(CoordinateFields.container,
  //       where: "${CoordinateFields.recordId} = ?",
  //       whereArgs: ["8eb1882f-5ad2-40cc-b04e-19076d27061f"]);
  //   return maps.map((map) {
  //     return Coordinate.fromMap(map);
  //   }).toList();
  // }
