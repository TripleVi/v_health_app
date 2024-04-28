import "dart:async";
import "dart:io" as io;
import "dart:math" as math;

import "package:camera/camera.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:geolocator/geolocator.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import "package:permission_handler/permission_handler.dart";
import "package:v_health/data/sources/sqlite/dao/workout_dao.dart";

import "../../../core/enum/activity_category.dart";
import "../../../core/enum/activity_tracking.dart";
import "../../../core/services/location_service.dart";
import "../../../domain/entities/activity_record.dart";
import "../../../domain/entities/position.dart";
import "../../../main.dart";
import "../../widgets/marker_painter.dart";
import "fitness_activity.dart";
import "cycling_activity.dart";
import "running_activity.dart";
import "walking_activity.dart";

part "activity_tracking_event.dart";
part "activity_tracking_state.dart";

class LocationSettingsRequest {
  final String title;
  final String description;
  final Future<void> Function() openSettings;

  LocationSettingsRequest({
    required this.title, 
    required this.description, 
    required this.openSettings,
  });

  factory LocationSettingsRequest.permissionGranted() {
    return LocationSettingsRequest(
      title: "Location Services",
      description: "You must open App Settings and grant Location Permission to record an activity",
      openSettings: LocationService.openAppSettings,
    );
  }

  factory LocationSettingsRequest.serviceEnabled() {
    return LocationSettingsRequest(
      title: "Location Services",
      description: "You must open Settings and enable Location Services to record an activity",
      openSettings: LocationService.openLocationSettings,
    );
  }

  factory LocationSettingsRequest.accuracyPrecise() {
    return LocationSettingsRequest(
      title: "Location Services",
      description: "You must open Settings and allow the app to use Precise Location to record an activity",
      openSettings: LocationService.openLocationSettings,
    );
  }

  factory LocationSettingsRequest.permissionAlways() {
    return LocationSettingsRequest(
      title: "Location Services",
      description: "You must open Settings and allow Location Permission as Always to record an activity in background",
      openSettings: LocationService.openLocationSettings,
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

class ActivityTrackingBloc extends Bloc<ActivityTrackingEvent, ActivityTrackingState> with WidgetsBindingObserver {
  var _pageVisibility = true;
  final _geoPoints = <LatLng>[];
  final _markers = <Marker>{};
  final _photosParams = <PhotoParams>[];
  AppPosition? _curtPos;
  FitnessActivity? activity;
  var trackingParams = const TrackingParams();

  final _timeStreamController = StreamController<int>.broadcast();
  late Timer _timer;
  int _secondsElapsed = 0;

  var _topMost = -double.maxFinite;
  var _rightMost = -double.maxFinite;
  var _leftMost = double.maxFinite;
  var _bottomMost = double.maxFinite;

  final _mapController = Completer<GoogleMapController>();
  var _isProcessing = true;
  var _isLocationAvail = true;
  var _locSvcEnabled = false;
  var _locPermission = LocationPermission.denied;
  var _locAccuracyStatus = LocationAccuracyStatus.reduced;
  

  var rawActiveData = <List<double>>[];

  ActivityTrackingBloc() : super(const ActivityTrackingState()) {
    on<TrackingStarted>(_onTrackingStarted);
    on<TrackingPaused>(_onTrackingPaused);
    on<TrackingResumed>(_onTrackingResumed);
    on<TrackingFinished>(_onTrackingFinished);
    on<TrackingDestroyed>(_onTrackingDestroyed);
    on<TrackingSaved>(_onTrackingSaved);
    on<DropDownItemSelected>(_onDropDownItemSelected);
    on<PictureTaken>(_onPictureTaken);
    on<PhotoMarkerTapped>(_onPhotoMarkerTapped);
    on<PhotoDeleted>(_onPhotoDeleted);
    on<PhotoEdited>(_onPhotoEdited);
    on<MetricsUpdated>(_onMetricsUpdated);
    on<RefreshScreen>(_onRefreshScreen);
    on<LocationUpdated>(_onLocationUpdated);
    on<CategorySelected>(_onCategorySelected);
    on<ToggleMetricsDialog>(_onMetricsDialogToggled);
    on<TogglePage>(_onPageToggled);

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      requestLocationPermission().then((_) async {
        if(isPrecise) {
          _isLocationAvail = true;
          add(const LocationUpdated());
        }
        _isProcessing = false;
      });
    });
  }

  bool get isReduced => _locAccuracyStatus == LocationAccuracyStatus.reduced;
  bool get isPrecise => _locAccuracyStatus == LocationAccuracyStatus.precise;
  bool get isDenied => _locPermission == LocationPermission.denied;
  bool get isDeniedForever => _locPermission == LocationPermission.deniedForever;

  Future<void> requestLocationPermission() async {
    _locSvcEnabled = await Geolocator.isLocationServiceEnabled();
    _locPermission = await Geolocator.checkPermission();
    // _locPermission cannot be deniedForever at this time.
    // No options are selected or it's been denied permanently before.
    if(isDenied) {
      // If the permission is denied forever, the dialog won't be shown again.
      _locPermission = await Geolocator.requestPermission();
      try {
        // To check whether options are selected.
        _locAccuracyStatus = await Geolocator.getLocationAccuracy();
        // It's been disallowed or selected and couldn't be denied.
      } on PlatformException catch (e) {
        // No options are selected. '_locPermission' is denied or deniedForever.
        if(e.code != "PERMISSION_DENIED") rethrow;
        // 'denied': the accuracy selected in the previous use is precise.
        // 'deniedForever': it's approximate, likewise.
        if(isDeniedForever) {
          // 'denied' is possible to request for the next time.
          // 'deniedForever' is impossible to request and needs to open app settings.
          _locPermission = LocationPermission.denied;
        }
      }
      return;
    }
    // The permission's been allowed before with approximate or precise accuracy.
    // If it's approximate, an accuracy dialog of precise will be shown.
    // If it's approximate permanently, nothing will happen.
    // It's impossible to know whether the selection is permanent.
    _locAccuracyStatus = await Geolocator.getLocationAccuracy();
    if(isPrecise) return;
    final result = await Permission.location.request();
    // 'denied': the previous accuracy is precise and no options are selected.
    // 'permanentlyDenied': the previous accuracy is approximate and no options are selected; the selected one is approximate permanently.
    // 'granted': the selected accuracy is precise.
    if(result.isGranted) {
      _locAccuracyStatus = LocationAccuracyStatus.precise;
    }
  }

  Future<void> handleLocationPermission(Emitter<ActivityTrackingState> emit) async {
    // This is called when users touch 'Start' or 'Resume' button.
    if(!_locSvcEnabled) {
      return emit(state.copyWith(
        request : LocationSettingsRequest.serviceEnabled(),
      ));
    }
    if(isDeniedForever) {
      return emit(state.copyWith(
        request : LocationSettingsRequest.permissionGranted(),
      ));
    }
    // No options were selected in the previous request.
    if(isDenied) {
      // If it's denied forever, the dialog won't be shown again.
      _locPermission = await Geolocator.requestPermission();
      try {
        // To check whether options are selected.
        _locAccuracyStatus = await Geolocator.getLocationAccuracy();
        // It's been disallowed or selected and couldn't be denied.
      } on PlatformException catch (e) {
        // No options are selected. Or it's changed to disallowed while using.
        if(e.code != "PERMISSION_DENIED") rethrow;
        // 'denied': the selected accuracy is precise.
        // 'deniedForever': the selected accuracy is approximate.
        if(isDeniedForever) {
          _locPermission = LocationPermission.denied;
        }
      }
      return;
    }
    _locAccuracyStatus = await Geolocator.getLocationAccuracy();
    if(isPrecise) return;
    final result = await Permission.location.request();
    if(result.isDenied) {
      _locAccuracyStatus = LocationAccuracyStatus.reduced;
    }else if(result.isPermanentlyDenied) {
      emit(state.copyWith(
        request: LocationSettingsRequest.accuracyPrecise(),
      ));
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _onAppStateResumed();
        break;
      case AppLifecycleState.paused:
        if(this.state.recState.isRecording) {
          backgroundService.invoke("appStateUpdated", {
            "state": "paused"
          });
        }
        break;
      default:
        break;
    }
  }

  Future<void> _onAppStateResumed() async {
    _isProcessing = true;
    if(state.recState.isRecording) {
      backgroundService.invoke("appStateUpdated", {
        "state": "resumed"
      });
    }
    var flag = true;
    final service = await Geolocator.isLocationServiceEnabled();
    if(service != _locSvcEnabled) {
      _locSvcEnabled = service;
      flag = false;
    }
    final permission = await Geolocator.checkPermission();
    // permission cannot be equal to 'deniedForever'.
    try {
      final accuracy = await Geolocator.getLocationAccuracy();
      // Permission's been selected and cannot be denied.
      if(permission != _locPermission) {
        _locPermission = permission;
        flag = false;
      }
      if(accuracy != _locAccuracyStatus) {
        _locAccuracyStatus = accuracy;
        flag = false;
      }
    } on PlatformException catch (e) {
      if(e.code != "PERMISSION_DENIED") {
        _isProcessing = false;
        rethrow;
      }
      // No options are selected. Or it's changed to disallowed while using.
      if(!isReduced) {
        _locAccuracyStatus = LocationAccuracyStatus.reduced;
        flag = false;
      }
      if(isDeniedForever) {
        _locPermission = LocationPermission.denied;
      }
    }
    if(flag) {
      _isProcessing = false;
      return;
    }
    if(!_locSvcEnabled || isDenied || isDeniedForever || isReduced) {
      _curtPos = null;
      if(state.recState.isRecording && !activity!.isPaused) {
        activity!.pauseRecording();
      }
      _isLocationAvail = false;
      add(const LocationUpdated());
    }else {
      await _onDesiredLocation();
      if(state.recState.isRecording && activity!.isPaused) {
        activity!.resumeRecording();
      }
      _isLocationAvail = true;
      add(const LocationUpdated());
    }
    _isProcessing = false;
  }

  Future<void> _onDesiredLocation() async {
    //? Accuracy status is precise and first time or location update's interrupted (currentPosition == null).
    //? currentPosition will be equal to 'null' only if it hasn't been initialized yet or tracking encounters errors.
    _curtPos = await LocationService().getCurrentPosition();
    final controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            _curtPos!.latitude,
            _curtPos!.longitude,
          ),
          zoom: 18.0,
        )
      )
    );
  }

  void _onCategorySelected(
    CategorySelected event,
    Emitter<ActivityTrackingState> emit,
  ) {
    emit(state.copyWith(category: event.category));
  }

  void _onMetricsDialogToggled(
    ToggleMetricsDialog event,
    Emitter<ActivityTrackingState> emit,
  ) {
    emit(state.copyWith(isMetricsVisible: !state.isMetricsVisible));
  }

  void _onPageToggled(
    TogglePage event,
    Emitter<ActivityTrackingState> emit,
  ) {
    _pageVisibility = !_pageVisibility;
    if(_pageVisibility) {
      emit(state);
    }
  }

  void initTrackingSession() {
    if(state.category.isWalking) {
      activity = WalkingActivity(
        onPositionsAcquired: (positions) {
          _curtPos = positions.length == 1 ? positions.first : positions.last;
          _geoPoints.addAll(positions.map((p) {
            _updateLatLngBounds(p);
            return LatLng(p.latitude, p.longitude);
          }));
          if(_pageVisibility) add(const LocationUpdated());  
        },
        onMetricsUpdated: () {
          final temp = activity as WalkingActivity;
          trackingParams = trackingParams.copyWith(
            distance: temp.totalDistance,
            speed: temp.instantSpeed,
            avgSpeed: temp.avgSpeed,
            calories: temp.totalCalories,
          );
          if(_pageVisibility) {
            add(const MetricsUpdated());
          }
        },
      );
    }else if(state.category.isRunning) {
      // activity = RunningActivity();
    }else if(state.category.isCycling) {
      activity = CyclingActivity(
        onPositionsAcquired: (positions) {
          _curtPos = positions.length == 1 ? positions.first : positions.last;
          _geoPoints.addAll(positions.map((p) {
            _updateLatLngBounds(p);
            return LatLng(p.latitude, p.longitude);
          }));
          final temp = activity as CyclingActivity;
          trackingParams = trackingParams.copyWith(
            distance: temp.totalDistance,
            speed: temp.instantSpeed,
            avgSpeed: temp.avgSpeed,
            calories: temp.totalCalories,
          );
          if(_pageVisibility) add(const LocationUpdated()); 
        },
      );
    }
  }

  Future<void> _onTrackingStarted(
    TrackingStarted event,
    Emitter<ActivityTrackingState> emit,
  ) async {
    if(_isProcessing) return;
    _isProcessing = true;
    await handleLocationPermission(emit);
    if(isPrecise) {
      trackingParams = TrackingParams(
        selectedTarget: state.trackingParams.selectedTarget,
        targetValue: event.targetValue,
      );
      await _onDesiredLocation();
      _geoPoints.add(LatLng(_curtPos!.latitude, _curtPos!.longitude));
      _updateLatLngBounds(_curtPos!);
      final pos = _curtPos!;
      final startMarker = await _setStartMarkers();
      _timer = _initializeTimer();
      _markers.add(Marker(
        markerId: const MarkerId("start_point"),
        position: LatLng(pos.latitude, pos.longitude),
        icon: startMarker,
      ));
      initTrackingSession();
      activity!.startRecording();
      emit(state.copyWith(
        geoPoints: _geoPoints,
        markers: _markers,
        timeStream: _timeStreamController.stream,
        recState: RecordingState.recording,
        trackingParams: TrackingParams(
          selectedTarget: state.trackingParams.selectedTarget,
          targetValue: event.targetValue,
        ),
      ));
    }
    _isProcessing = false;
  }

  void _onTrackingPaused(
    TrackingPaused event, 
    Emitter<ActivityTrackingState> emit,
  ) {
    activity!.pauseRecording();
    _timer.cancel();
    emit(state.copyWith(recState: RecordingState.paused));
  }

  Future<void> _onTrackingResumed(
    TrackingResumed event,
    Emitter<ActivityTrackingState> emit,
  ) async {
    if(_isProcessing) return;
    _isProcessing = true;
    await handleLocationPermission(emit);
    if(isPrecise) {
      await _onDesiredLocation();
      activity!.resumeRecording();
      _timer = _initializeTimer();
      emit(state.copyWith(recState: RecordingState.recording));
    }
    _isProcessing = false;
  }

  Future<void> _onTrackingFinished(
    TrackingFinished event, 
    Emitter<ActivityTrackingState> emit,
  ) async {
    // if(_isProcessing) return;
    // _isProcessing = true;
    final endMarker = await _setEndMarkers();
    _markers.add(Marker(
      markerId: const MarkerId("end_point"),
      position: LatLng(_curtPos!.latitude, _curtPos!.longitude),
      icon: endMarker,
    ));
    emit(state.copyWith());
    return;
    final temp = activity as WalkingActivity;
    // if(temp.activeTime <= 60 || temp.totalDistance <= 5.0) {
    //   emit(state.copyWith(isQualified: false));
    //   return;
    // }
    final record = ActivityRecord.empty()
    ..category = state.category
    ..startDate = activity!.startDate
    ..activeTime = temp.activeTime
    ..distance = temp.totalDistance
    ..avgSpeed = temp.avgSpeed
    ..maxSpeed = temp.maxSpeed
    ..calories = temp.totalCalories
    ..data = temp.workoutData;

    final repo = WorkoutDao();
    record.data = await repo.getManyAccelData();

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
    _isProcessing = false;
  }

  Future<void> _onTrackingDestroyed(
    TrackingDestroyed event, 
    Emitter<ActivityTrackingState> emit,
  ) async {
    clearSession();
    emit(const ActivityTrackingState());
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }

  void _onPhotoDeleted(
    PhotoDeleted event,
    Emitter<ActivityTrackingState> emit,
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

  void _onRefreshScreen(
    RefreshScreen event,
    Emitter<ActivityTrackingState> emit,
  ) {
    emit(state.copyWith());
  }

  void _onMetricsUpdated(
    MetricsUpdated event,
    Emitter<ActivityTrackingState> emit,
  ) {
    emit(state.copyWith(trackingParams: trackingParams));
  }

  void _onPhotoEdited(
    PhotoEdited event,
    Emitter<ActivityTrackingState> emit,
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
    Emitter<ActivityTrackingState> emit,
  ) {
    emit(state.copyWith(photo: event.photo));
  }

  void _onLocationUpdated(
    LocationUpdated event,
    Emitter<ActivityTrackingState> emit,
  ) {
    emit(state.copyWith(isLocationAvail: _isLocationAvail));
  }

  Future<void> _onTrackingSaved(
    TrackingSaved event,
    Emitter<ActivityTrackingState> emit,
  ) async {
    if(event.success == null) {
      _markers.remove(_markers.last);
      emit(state.copyWith());
    }else if(event.success == true) {
      clearSession();
      emit(const ActivityTrackingState(snackMsg: "Adding post succeed"));
    }else {
      _markers.remove(_markers.last);
      emit(state.copyWith(snackMsg: "Adding post failed"));
    }
  }

  void clearSession() {
    _geoPoints.clear();
    _markers.clear();
    _photosParams.clear();
    _timer.cancel();
    activity?.stopRecording();
    activity = null;
    _secondsElapsed = 0;
    _topMost = -double.maxFinite;
    _rightMost = -double.maxFinite;
    _leftMost = double.maxFinite;
    _bottomMost = double.maxFinite;
    trackingParams = const TrackingParams();
  }

  void _onDropDownItemSelected(
    DropDownItemSelected event, 
    Emitter<ActivityTrackingState> emit,
  ) {
    emit(state.copyWith(
      trackingParams: TrackingParams(
        selectedTarget: event.selectedItem,
      ),
    ));
  }

  Future<void> _onPictureTaken(
    PictureTaken event,
    Emitter<ActivityTrackingState> emit,
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

  Future<BitmapDescriptor> _setStartMarkers() async {
    return BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty, 
      "assets/images/start_marker.png",
    );
  }

  Future<BitmapDescriptor> _setEndMarkers() async {
    return BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty, 
      "assets/images/flag.png",
    );
  }

  void _updateLatLngBounds(AppPosition position) {
    _topMost = math.max(_topMost, position.latitude);
    _rightMost = math.max(_rightMost, position.longitude);
    _bottomMost = math.min(_bottomMost, position.latitude);
    _leftMost = math.min(_leftMost, position.longitude);
  }

  Timer _initializeTimer() {
    return Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsElapsed++;
      _timeStreamController.add(_secondsElapsed);
    });
  }

  @override
  Future<void> close() async {
    super.close();
    await _timeStreamController.close();
    (await _mapController.future).dispose();
    clearSession();
    WidgetsBinding.instance.removeObserver(this);
  }
}
