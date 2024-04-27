class WorkoutData {
  int steps;
  double speed;
  double distance;
  double calories;
  int time;

  WorkoutData({
    required this.speed,
    required this.distance,
    required this.steps,
    required this.calories,
    required this.time,
  });

  factory WorkoutData.fromMap(Map<String, dynamic> map) {
    return WorkoutData(
      steps: map["steps"], 
      speed: map["speed"], 
      distance: map["distance"], 
      calories: map["calories"], 
      time: map["time"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "steps": steps,
      "distance": distance,
      "time": time,
      "calories": calories,
      "speed": speed,
    };
  }

  @override
  String toString() {
    return "WorkoutData{steps: $steps, distance: $distance, time: $time, calories: $calories, speed: $speed}";
  }
}