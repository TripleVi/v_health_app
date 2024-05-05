class WorkoutData {
  double speed;
  int time;

  WorkoutData({
    required this.speed,
    required this.time,
  });

  factory WorkoutData.empty() {
    return WorkoutData(speed: 0, time: 0);
  }

  factory WorkoutData.fromMap(Map<String, dynamic> map) {
    return WorkoutData(
      speed: map["speed"], 
      time: map["time"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "speed": speed,
      "time": time,
    };
  }

  @override
  String toString() {
    return "WorkoutData{speed: $speed, time: $time}";
  }
}