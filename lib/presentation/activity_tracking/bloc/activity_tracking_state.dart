part of "activity_tracking_bloc.dart";

@immutable
class ActivityTrackingState {
  final ActivityCategory category;
  final List<LatLng> geoPoints;
  final Set<Marker> markers;
  final RecordingState recState;
  final bool isLocationAvail;
  final LocationSettingsRequest? request;
  final TrackingParams trackingParams;
  final Stream<int>? timeStream;
  final TrackingResult? result;
  final XFile? photo;
  final bool isMetricsVisible;
  final bool isQualified;
  final String? snackMsg;

  const ActivityTrackingState({
    this.category = ActivityCategory.walking,
    this.geoPoints = const [],
    this.markers = const {},
    this.recState = RecordingState.initial,
    this.isLocationAvail = false,
    this.request,
    this.timeStream,
    this.trackingParams = const TrackingParams(),
    this.result,
    this.photo,
    this.isMetricsVisible = false,
    this.isQualified = true,
    this.snackMsg,
  });

  ActivityTrackingState copyWith({
    ActivityCategory? category,
    List<LatLng>? geoPoints,
    Set<Marker>? markers,
    RecordingState? recState,
    bool? isLocationAvail,
    LocationSettingsRequest? request,
    TrackingParams? trackingParams,
    Stream<int>? timeStream,
    TrackingResult? result,
    XFile? photo,
    bool? isMetricsVisible,
    bool isQualified = true,
    String? snackMsg,
  }) {
    return ActivityTrackingState(
      category: category ?? this.category,
      geoPoints: geoPoints ?? this.geoPoints,
      markers: markers ?? this.markers,
      recState: recState ?? this.recState,
      isLocationAvail: isLocationAvail ?? this.isLocationAvail,
      request: request,
      trackingParams: trackingParams ?? this.trackingParams,
      timeStream: timeStream ?? this.timeStream,
      result: result,
      photo: photo,
      isMetricsVisible: isMetricsVisible ?? this.isMetricsVisible,
      isQualified: isQualified,
      snackMsg: snackMsg,
    );
  }
}

class TrackingParams {
  final double distance;
  final double? speed;
  final double avgSpeed;
  final double calories;
  final TrackingTarget selectedTarget;
  final double? targetValue;

  const TrackingParams({
    this.distance = 0.0, 
    this.speed, 
    this.avgSpeed = 0.0, 
    this.calories = 0,
    this.selectedTarget = TrackingTarget.distance,
    this.targetValue,
  });

  TrackingParams copyWith({
    required double distance, 
    double? speed, 
    required double avgSpeed, 
    double? pace, 
    double? avgPace,  
    required double calories,
  }) {
    return TrackingParams(
      distance: distance,
      speed: speed,
      avgSpeed: avgSpeed,
      calories: calories,
      selectedTarget: selectedTarget,
      targetValue: targetValue,
    );
  }
}