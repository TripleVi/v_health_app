class WorkoutData {
  int steps;
  double speed;
  double distance;
  double calories;
  int time;

  WorkoutData({
    required this.steps,
    required this.speed,
    required this.distance,
    required this.calories,
    required this.time,
  });

  factory WorkoutData.empty() {
    return WorkoutData(steps: 0, speed: 0, distance: 0, calories: 0, time: 0);
  }

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
    return "WorkoutData{steps: $steps, speed: $speed, distance: $distance, calories: $calories, time: $time}";
  }
}