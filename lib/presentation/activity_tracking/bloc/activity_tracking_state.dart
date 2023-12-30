part of 'activity_tracking_bloc.dart';

@immutable
class TrackingState {
  final ActivityCategory category;
  final List<LatLng> geoPoints;
  final Set<Marker> markers;
  final TrackingStatus status;
  final LocationSettingsRequest? request;
  final TrackingParams trackingParams;
  final Stream<int>? timeStream;
  final TrackingResult? result;
  final io.File? photo;

  const TrackingState({
    this.category = ActivityCategory.walking,
    this.geoPoints = const [],
    this.markers = const {},
    this.status = TrackingStatus.initial,
    this.request,
    this.timeStream,
    this.trackingParams = const TrackingParams(),
    this.result,
    this.photo,
  });

  TrackingState copyWith({
    ActivityCategory? category,
    List<LatLng>? geoPoints,
    Set<Marker>? markers,
    TrackingStatus? status,
    LocationSettingsRequest? request,
    TrackingParams? trackingParams,
    Stream<int>? timeStream,
    TrackingResult? result,
    io.File? photo,
  }) {
    return TrackingState(
      category: category ?? this.category,
      geoPoints: geoPoints ?? this.geoPoints,
      markers: markers ?? this.markers,
      status: status ?? this.status,
      request: request,
      trackingParams: trackingParams ?? this.trackingParams,
      timeStream: timeStream ?? this.timeStream,
      result: result,
      photo: photo,
    );
  }
}

class TrackingParams {
  final double distance;
  final double? speed;
  final double? avgSpeed;
  final double? pace;
  final double? avgPace;
  final int calories;
  final TrackingTarget selectedTarget;
  final double? targetValue;

  const TrackingParams({
    this.distance = 0.0, 
    this.speed, 
    this.avgSpeed, 
    this.pace, 
    this.avgPace, 
    this.calories = 0,
    this.selectedTarget = TrackingTarget.distance,
    this.targetValue,
  });

  TrackingParams copyWith({
    required double distance, 
    double? speed, 
    double? avgSpeed, 
    double? pace, 
    double? avgPace,  
    required int calories,
  }) {
    return TrackingParams(
      distance: distance,
      speed: speed,
      avgSpeed: avgSpeed,
      pace: pace,
      avgPace: avgPace,
      calories: calories,
      selectedTarget: selectedTarget,
      targetValue: targetValue,
    );
  }
}