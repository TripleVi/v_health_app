import 'dart:async';
import 'dart:io' as io;
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/enum/activity_tracking.dart';
import '../../../core/services/location_service.dart';
import '../../../domain/entities/activity_record.dart';
import '../../../domain/entities/workout_data.dart';
import '../../../main.dart';
import '../widgets/marker_painter.dart';

part 'activity_tracking_event.dart';
part 'activity_tracking_state.dart';

class PermissionParams {
  final String title;
  final String content;
  final Future<void> Function() openSettings;

  PermissionParams._(this.title, this.content, this.openSettings);

  static PermissionParams get deniedForever {
    return PermissionParams._(
      "Location Services",
      "You must open App Settings and grant Location Permission to record an activity",
      LocationService.openAppSettings,
    );
  }

  static PermissionParams get serviceDisabled {
    return PermissionParams._(
      "Location Services",
      "You must open Settings and enable Location Services to record an activity",
      LocationService.openLocationSettings,
    );
  } 

  static PermissionParams get accuracyStatusReduced {
    return PermissionParams._(
      "Location Services",
      "You must open Settings and allow the app to use Precise Location to record an activity",
      LocationService.openAppSettings,
    );
  }  
}

class PhotoParams {
  XFile file;
  double latitude;
  double longitude;

  PhotoParams({
    required this.file,
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() {
    return "PhotoTaken{path: ${file.path}, latitude: $latitude, longitude: $longitude}";
  }
}

class TrackingResult {
  final List<LatLng> geoPoints;
  final List<PhotoParams> photosParams;
  final ActivityRecord record;
  final Completer<GoogleMapController> controller;
  final LatLngBounds latLngBounds;

  TrackingResult({
    required this.geoPoints, 
    required this.photosParams,
    required this.record,
    required this.controller,
    required this.latLngBounds,
  });
}

class ActivityTrackingBloc extends Bloc<ActivityTrackingEvent, TrackingState> {
  final _geoPoints = <LatLng>[];
  final _markers = <Marker>{};
  final _photosParams = <PhotoParams>[];
  final _workoutData = <WorkoutData>[];
  Position? _currentPosition;
  Position? _lastKnownPosition;
  StreamSubscription<Position>? _positionSubscriber;

  final _locationService = GetIt.instance<LocationService>();
  final _timeStreamController = StreamController<int>.broadcast();
  late Timer _timer;
  int _secondsElapsed = 0;

  var _topMost = -double.maxFinite;
  var _rightMost = -double.maxFinite;
  var _leftMost = double.maxFinite;
  var _bottomMost = double.maxFinite;

  double _totalDistance = 0.0;
  double? _instantSpeed;
  double? _avgSpeed;
  double _maxSpeed = 0.0;
  double? _instantPace;
  double? _avgPace;
  double _maxPace = 0.0;
  int _calories = 0;

  final _mapController = Completer<GoogleMapController>();
  DateTime? _startDate;
  bool _permissionRequesting = true;

  ActivityTrackingBloc() : super(const TrackingState()) {
    on<TrackingStarted>(_onTrackingStarted);
    on<TrackingPaused>(_onTrackingPaused);
    on<TrackingResumed>(_onTrackingResumed);
    on<TrackingFinished>(_onTrackingFinished);
    on<TrackingSaved>(_onTrackingSaved);
    on<DropDownItemSelected>(_onDropDownItemSelected);
    on<PictureTaken>(_onPictureTaken);
    on<PhotoMarkerTapped>(_onPhotoMarkerTapped);
    on<PhotoDeleted>(_onPhotoDeleted);
    on<PhotoEdited>(_onPhotoEdited);
    on<RefreshTracking>(_onRefreshTracking);
    on<LocationUpdated>(_onLocationUpdated);

    _locationService.requestPermission().then((value) async {
      if(value.isPrecise) {
        await _onDesiredLocation();
      }
      _permissionRequesting = false;
    });
    _handleLocationUpdates();
  }

  void _handleLocationUpdates() {
    _positionSubscriber = backgroundService
        .on("positionAcquired")
        .map((event) {
          event!["position"]["altitude"] *= 1.0;
          event["position"]["accuracy"] *= 1.0;
          event["position"]["altitude_accuracy"] *= 1.0;
          event["position"]["heading_accuracy"] *= 1.0;
          event["position"]["speed"] *= 1.0;
          event["position"]["speed_accuracy"] *= 1.0;
          return Position.fromMap(event["position"]);
        })
        .listen((position) {
      final timeFrame = _secondsElapsed;
      _lastKnownPosition = _currentPosition;
      _currentPosition = position;
      if (state.status.isStarted) {
        _geoPoints.add(LatLng(position.latitude, position.longitude));
        _updateMetrics(_lastKnownPosition!, _currentPosition!, timeFrame);
        _workoutData.add(WorkoutData( 
          speed: _instantSpeed!,
          pace: _instantPace!,
          distance: _totalDistance,
          timeFrame: timeFrame,
        ));
        _updateLatLngBounds(position);
      }
      add(const LocationUpdated());
    });

    backgroundService.on("trackingError").listen((_) async {
      //? Location update encounters errors
      _currentPosition = null;
      add(const LocationUpdated());
    });
  }

  Future<void> _onDesiredLocation() async {
    //? Accuracy status is precise and first time or location update's interrupted (currentPosition == null).
    //? currentPosition will be equal to 'null' only if it hasn't been initialized yet or tracking encounters errors.
    //? Start listening to location updates in the foreground service.
    backgroundService.invoke("trackingStarted");
    _currentPosition = await _locationService.getCurrentPosition();
    _lastKnownPosition = _currentPosition!;
    final controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          zoom: 18.0,
        )
      )
    );
  }

  Future<void> _onTrackingStarted(
    TrackingStarted event,
    Emitter<TrackingState> emit,
  ) async {
    if(_permissionRequesting) return;
    _permissionRequesting = true;
    final response = await _locationService.requestPermission();
    if (!response.isServiceEnabled) {
      _permissionRequesting = false;
      return emit(state.copyWith(
        permissionParams: PermissionParams.serviceDisabled,
      ));
    } else if (response.isDeniedForever) {
      _permissionRequesting = false;
      return emit(state.copyWith(
        permissionParams: PermissionParams.deniedForever,
      ));
    }
    if (response.isPrecise) {
      if(_currentPosition == null) {
        await _onDesiredLocation();
      }
      final pos = _currentPosition!;
      final startingMarker = await _setCustomMarkers();
      _startDate = DateTime.now();
      _timer = _initializeTimer();
      _markers.add(Marker(
        markerId: const MarkerId("starting_position"),
        position: LatLng(pos.latitude, pos.longitude),
        icon: startingMarker,
      ));
      _geoPoints.add(LatLng(pos.latitude, pos.longitude));
      _updateLatLngBounds(pos);
      _workoutData.add(WorkoutData.empty());
      emit(state.copyWith(
        geoPoints: _geoPoints,
        markers: _markers,
        timeStream: _timeStreamController.stream,
        status: TrackingStatus.started,
        trackingParams: TrackingParams(
          selectedTarget: state.trackingParams.selectedTarget,
          targetValue: event.targetValue,
        ),
      ));
    }else {
      emit(state.copyWith(
        permissionParams: PermissionParams.accuracyStatusReduced,
      ));
    }
    _permissionRequesting = false;
  }

  void _onTrackingPaused(           
    TrackingPaused event, 
    Emitter<TrackingState> emit,
  ) {
    backgroundService.invoke("trackingPaused");
    _timer.cancel();
    emit(state.copyWith(status: TrackingStatus.paused));
  }

  Future<void> _onTrackingResumed(
    TrackingResumed event,
    Emitter<TrackingState> emit,
  ) async {
    if(_permissionRequesting) return;
    _permissionRequesting = true;
    final response = await _locationService.requestPermission();
    if (!response.isServiceEnabled) {
      _permissionRequesting = false;
      return emit(state.copyWith(
        permissionParams: PermissionParams.serviceDisabled,
      ));
    } else if (response.isDeniedForever) {
      _permissionRequesting = false;
      return emit(state.copyWith(
        permissionParams: PermissionParams.deniedForever,
      ));
    }
    if (response.isPrecise) {
      if(_currentPosition == null) {
        await _onDesiredLocation();
      }else {
        backgroundService.invoke("trackingResumed");
      }
      _timer = _initializeTimer();
      emit(state.copyWith(status: TrackingStatus.started));
    }
    _permissionRequesting = false;
  }

  Future<void> _onTrackingFinished(
    TrackingFinished event, 
    Emitter<TrackingState> emit,
  ) async {
    final record = ActivityRecord(
      startDate: _startDate!,
      endDate: DateTime.now(),
      workoutDuration: _secondsElapsed,
      distance: _totalDistance,
      avgSpeed: _avgSpeed!,
      maxSpeed: _maxSpeed,
      avgPace: _avgPace!,
      maxPace: _maxPace,
      calories: _calories,
      data: _workoutData,
      steps: 0,
      stairsClimbed: 0,
    );

    emit(state.copyWith(
      result: TrackingResult(
        geoPoints: _geoPoints,
        photosParams: _photosParams,
        record: record,
        controller: _mapController,
        latLngBounds: LatLngBounds(
          northeast: LatLng(_topMost, _rightMost),
          southwest: LatLng(_bottomMost, _leftMost),
        ),
      ),
    ));
  }

  void _destroyTrackingSession() {
    _geoPoints.clear();
    _markers.clear();
    _photosParams.clear();
    _workoutData.clear();
    _timer.cancel();
    _secondsElapsed = 0;
    _startDate = null;
    _topMost = -double.maxFinite;
    _rightMost = -double.maxFinite;
    _leftMost = double.maxFinite;
    _bottomMost = double.maxFinite;
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }

  void _onPhotoDeleted(
    PhotoDeleted event,
    Emitter<TrackingState> emit,
  ) {
    final photo = event.file;
    // final name = MyUtils.getFileName(photo);
    photo.deleteSync();
    // for(final m in _markers) {
    //   if(m.markerId.value == name) {
    //     _markers.remove(m);
    //     break;
    //   }
    // }
    for(final p in _photosParams) {
      if(p.file.hashCode == photo.hashCode) {
        _photosParams.remove(p);
        break;
      }
    }
    emit(state.copyWith());
  }

  void _onRefreshTracking(
    RefreshTracking event,
    Emitter<TrackingState> emit,
  ) {
    emit(state.copyWith());
  }

  void _onPhotoEdited(
    PhotoEdited event,
    Emitter<TrackingState> emit,
  ) {
    // final original = event.originalFile;
    // final editedBytes = event.editedBytes;
    // original.writeAsBytesSync(editedBytes);
    // final name = MyUtils.getFileName(original);
    // for(final m in _markers) {
    //   if(m.markerId.value == name) {
    //     _markers.remove(m);
    //     MarkerPainter.getMarkerBytes(editedBytes).then((value) {
    //       _markers.add(Marker(
    //         markerId: MarkerId(name),
    //         position: LatLng(m.position.latitude, m.position.longitude),
    //         icon: BitmapDescriptor.fromBytes(value),
    //         onTap: () => add(PhotoMarkerTapped(original)),
    //       ));
    //     });
    //     break;
    //   }
    // }
  }
 
  void _onPhotoMarkerTapped(
    PhotoMarkerTapped event,
    Emitter<TrackingState> emit,
  ) {
    emit(state.copyWith(photo: event.photo));
  }

  void _onLocationUpdated(
    LocationUpdated event,
    Emitter<TrackingState> emit,
  ) {
    emit(state.copyWith(
      trackingParams: state.trackingParams.copyWith(
        distance: _totalDistance,
        speed: _instantSpeed,
        avgSpeed: _avgSpeed,
        pace: _instantPace,
        avgPace: _avgPace,
        calories: _calories,
      )
    ));
  }

  Future<void> _onTrackingSaved(
    TrackingSaved event,
    Emitter<TrackingState> emit,
  ) async {
    if(!event.isSuccess) return;
    _destroyTrackingSession();
    emit(const TrackingState());
  }

  void _onDropDownItemSelected(
    DropDownItemSelected event, 
    Emitter<TrackingState> emit,
  ) {
    emit(state.copyWith(
      trackingParams: TrackingParams(
        selectedTarget: event.selectedItem,
      ),
    ));
  }

  Future<void> _onPictureTaken(
    PictureTaken event,
    Emitter<TrackingState> emit,
  ) async {
    final params = event.params;
    _photosParams.add(params);
    final pictureBytes = await params.file.readAsBytes();
    final markerBytes = await MarkerPainter.getMarkerBytes(pictureBytes);
    // final fileName = MyUtils.getFileName(params.file);
    _markers.add(Marker(
      markerId: MarkerId(params.file.name),
      position: LatLng(params.latitude, params.longitude),
      icon: BitmapDescriptor.fromBytes(markerBytes),
      onTap: () => add(PhotoMarkerTapped(io.File(params.file.path))),
    ));
    emit(state.copyWith());
  }

  Future<BitmapDescriptor> _setCustomMarkers() async {
    return BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty, 
      "assets/images/start_marker.png",
    );
  }

  void _updateLatLngBounds(Position position) {
    _topMost = math.max(_topMost, position.latitude);
    _rightMost = math.max(_rightMost, position.longitude);
    _bottomMost = math.min(_bottomMost, position.latitude);
    _leftMost = math.min(_leftMost, position.longitude);
  }

  void _updateMetrics(Position prev, Position next, int timeFrame) {
    // m
    final distance = _locationService.distanceBetween(
      prev.latitude, prev.longitude,
      next.latitude, next.longitude,
    );
    _totalDistance += distance;
    // s
    final duration = next.timestamp!.difference(prev.timestamp!).inSeconds;
    // m/s
    _instantSpeed = distance / duration;
    _avgSpeed = _totalDistance / timeFrame;
    if(_instantSpeed! > _maxSpeed) {
      _maxSpeed = _instantSpeed!;
    }
    // s/m
    _instantPace = duration / distance;
    _avgPace = timeFrame / _totalDistance;
    if(_instantPace! > _maxPace) {
      _maxPace = _instantPace!;
    }
    // final user = await _userFuture;
    const met = 7;
    // _workoutCalories += (timeFrame / 60 * met * 3.5 * user.weight / 200).floor();
    _calories = _calories;
  }

  Timer _initializeTimer() {
    return Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsElapsed++;
      _timeStreamController.add(_secondsElapsed);
    });
  }

  @override
  Future<void> close() async {
    await _positionSubscriber?.cancel();
    await _timeStreamController.close();
    backgroundService.invoke("trackingStopped");
    return super.close();
  }
}
