class WorkoutData {
  double speed;
  double distance;
  int steps;
  double calories;
  int activeTime;

  WorkoutData({
    required this.speed,
    required this.distance,
    required this.steps,
    required this.calories,
    required this.activeTime,
  });

  // factory WorkoutData.empty() {
  //   return WorkoutData(speed: 0.0, distance: 0.0, timeFrame: 0);
  // }

  Map<String, dynamic> toMap() {
    return {
      "speed": speed,
      "distance": distance,
      "activeTime": activeTime,
    };
  }

  @override
  String toString() {
    return "WorkoutData{speed: $speed, distance: $distance, activeTime: $activeTime}";
  }
}