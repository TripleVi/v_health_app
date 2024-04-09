import '../../data/sources/table_attributes.dart';

class DailyGoal {
  int id;
  int steps;
  // minute
  int activeTime;
  // kcal
  int calories;

  DailyGoal({
    required this.id,
    required this.steps,
    required this.activeTime,
    required this.calories,
  });

  factory DailyGoal.empty() {
    return DailyGoal(
      id: -1, 
      steps: 6000, 
      activeTime: 90, 
      calories: 500,
    );
  }

  factory DailyGoal.fromSqlite(Map<String, dynamic> map) {
    return DailyGoal(
      id: map[DailyGoalFields.id],
      steps: map[DailyGoalFields.steps],
      activeTime: map[DailyGoalFields.minutes],
      calories: map[DailyGoalFields.calories],
    );
  }

  Map<String, dynamic> toSqlite() {
    return {
      DailyGoalFields.steps: steps,
      DailyGoalFields.minutes: activeTime,
      DailyGoalFields.calories: calories,
    };
  }

  @override
  String toString() {
    return "{id: $id, steps: $steps, activeTime: $activeTime, calories: $calories}";
  }
}
