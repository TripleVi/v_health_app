import "../../core/enum/activity_category.dart";
import "coordinate.dart";
import "photo.dart";
import "workout_data.dart";

class ActivityRecord {
  ActivityCategory category;
  DateTime startDate;
  DateTime endDate;
  int activeTime;
  double distance;
  double avgSpeed;
  double maxSpeed;
  int steps;
  double calories;
  List<Coordinate> coordinates;
  List<Photo> photos;
  List<WorkoutData> data;

  ActivityRecord({
    required this.category,
    required this.startDate,
    required this.endDate,
    required this.activeTime,
    required this.distance,
    required this.avgSpeed,
    required this.maxSpeed,
    required this.steps,
    required this.calories,
    this.coordinates = const [],
    this.photos = const [],
    this.data = const [],
  });

  factory ActivityRecord.empty() {
    final date = DateTime.now();
    return ActivityRecord(category: ActivityCategory.walking, startDate: date, endDate: date, activeTime: 0, distance: 0, avgSpeed: 0, maxSpeed: 0, steps: 0, calories: 0);
  }

  factory ActivityRecord.fromMap(Map<String, dynamic> map) {
    return ActivityRecord(
      category: ActivityCategory.values[map["category"]],
      startDate: DateTime.fromMillisecondsSinceEpoch(map["startDate"]),
      endDate: DateTime.fromMillisecondsSinceEpoch(map["endDate"]),
      activeTime: map["activeTime"],
      distance: map["distance"]*1.0,
      avgSpeed: map["avgSpeed"]*1.0,
      maxSpeed: map["maxSpeed"]*1.0,
      steps: map["steps"],
      calories: map["calories"]*1.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "category": category.index,
      "startDate": startDate.millisecondsSinceEpoch,
      "endDate": endDate.millisecondsSinceEpoch,
      "activeTime": activeTime,
      "distance": distance,
      "avgSpeed": avgSpeed,
      "maxSpeed": maxSpeed,
      "steps": steps,
      "calories": calories,
    };
  }

  @override
  String toString() {
    return "ActivityRecord{category: ${category.name}, startDate: $startDate, endDate: $startDate, activeTime: $activeTime, distance: $distance, avgSpeed: $avgSpeed, maxSpeed: $maxSpeed, steps: $steps, calories: $calories}";
  }
}
