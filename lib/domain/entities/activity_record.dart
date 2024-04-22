import '../../core/enum/activity_category.dart';
import 'base_entity.dart';
import 'coordinate.dart';
import 'photo.dart';
import 'workout_data.dart';

class ActivityRecord extends BaseEntity {
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
    super.id,
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
    return ActivityRecord(category: ActivityCategory.walking, startDate: date, endDate: date, activeTime: 0, distance: 0.0, avgSpeed: 0.0, maxSpeed: 0.0, steps: 0, calories: 0);
  }

  // ActivityRecord.before_i_days(String startDate, int i)
  //     : this(startDate: MyUtils.get_date_subtracted_by_i(startDate, i), endDate: DateTime.now());

  // ActivityRecord.fromMap(Map<String, dynamic> map) : this(
  //   id: map[ActivityRecordFields.id],
  //   startDate: MyUtils
  //       .getLocalDateTime(map[ActivityRecordFields.startDate]),
  //   endDate: MyUtils
  //       .getLocalDateTime(map[ActivityRecordFields.endDate]),
  //   workoutDuration: map[ActivityRecordFields.workoutDuration].round(),
  //   distance: map[ActivityRecordFields.distance],
  //   avgSpeed: map[ActivityRecordFields.avgSpeed],
  //   maxSpeed: map[ActivityRecordFields.maxSpeed],
  //   avgPace: map[ActivityRecordFields.avgPace],
  //   maxPace: map[ActivityRecordFields.maxPace],
  //   steps: map[ActivityRecordFields.steps],
  //   stairsClimbed: map[ActivityRecordFields.stairsClimbed],
  //   workoutCalories: map[ActivityRecordFields.workoutCalories].round(),
  //   totalCalories: map[ActivityRecordFields.totalCalories].round(),
  //   mapName: map[ActivityRecordFields.mapName],
  //   mapUrl: map["mapUrl"],
  // );

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
    return "ActivityRecord{id: $id, category: ${category.name}, startDate: $startDate, endDate: $startDate, activeTime: $activeTime, distance: $distance, avgSpeed: $avgSpeed, maxSpeed: $maxSpeed, steps: $steps, calories: $calories}";
  }
}
