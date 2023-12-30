enum RecordingState {initial, recording, paused}

extension RecordingStateExtension on RecordingState {
  bool get isInitial => this == RecordingState.initial;
  bool get isRecording => this == RecordingState.recording;
  bool get isPaused => this == RecordingState.paused;
}

enum TrackingTarget {
  distance, 
  duration, 
  calories, 
  noTarget,
}

extension TrackingTargetExtension on TrackingTarget {
  bool get isDistance => this == TrackingTarget.distance;
  bool get isDuration => this == TrackingTarget.duration;
  bool get isCalories => this == TrackingTarget.calories;
  bool get isNotTargeted => this == TrackingTarget.noTarget;

  String get stringValue {
    switch (this) {
      case TrackingTarget.distance:
        return "Distance target";
      case TrackingTarget.duration:
        return "Duration target";
      case TrackingTarget.calories:
        return "Calories target";
      case TrackingTarget.noTarget:
        return "No target";
      default:
        return "";
    }
  }
}