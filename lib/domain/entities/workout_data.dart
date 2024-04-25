class WorkoutData {
  double speed;
  double distance;
  int steps;
  int calories;
  int timeFrame;

  WorkoutData({
    required this.speed,
    required this.distance,
    required this.steps,
    required this.calories,
    required this.timeFrame,
  });

  // factory WorkoutData.empty() {
  //   return WorkoutData(speed: 0.0, distance: 0.0, timeFrame: 0);
  // }

  Map<String, dynamic> toMap() {
    return {
      "speed": speed,
      "distance": distance,
      "timeFrame": timeFrame,
    };
  }

  @override
  String toString() {
    return "WorkoutData{speed: $speed, distance: $distance, timeFrame: $timeFrame}";
  }
}