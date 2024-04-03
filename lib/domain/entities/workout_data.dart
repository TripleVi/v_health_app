class WorkoutData {
  double speed;
  double totalDistance;
  int timeFrame;

  WorkoutData({
    required this.speed,
    required this.totalDistance,
    required this.timeFrame,
  });

  factory WorkoutData.empty() {
    return WorkoutData(speed: 0.0, totalDistance: 0.0, timeFrame: 0);
  }

  Map<String, dynamic> toMap() {
    return {
      "speed": speed,
      "distance": totalDistance,
      "timeFrame": timeFrame,
    };
  }

  @override
  String toString() {
    return "WorkoutData{speed: $speed, distance: $totalDistance, timeFrame: $timeFrame}";
  }
}