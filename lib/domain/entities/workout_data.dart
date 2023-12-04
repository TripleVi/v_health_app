class WorkoutData {
  double speed;
  double pace;
  double distance;
  int timeFrame;

  WorkoutData({
    required this.speed,
    required this.pace,
    required this.distance,
    required this.timeFrame,
  });

  factory WorkoutData.empty() {
    return WorkoutData(speed: 0.0, pace: 0.0, distance: 0.0, timeFrame: 0);
  }

  Map<String, dynamic> toMap() {
    return {
      "speed": speed,
      "pace": pace,
      "distance": distance,
      "timeFrame": timeFrame,
    };
  }

  @override
  String toString() {
    return "WorkoutData{speed: $speed, pace: $pace, distance: $distance, timeFrame: $timeFrame}";
  }
}