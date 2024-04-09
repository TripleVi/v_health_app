import "../../core/utilities/utils.dart";
import "../../data/sources/table_attributes.dart";
import "daily_goal.dart";

class DailyReport {
  int id;
  DateTime date;
  int steps;
  // meter
  double distance;
  // minute
  int activeTime;
  // cal
  int calories;
  DailyGoal goal;

  DailyReport({
    required this.id,
    required this.date, 
    required this.steps, 
    required this.distance, 
    required this.activeTime,
    required this.calories,
    DailyGoal? goal,
  })
  : goal = goal ?? DailyGoal.empty();

  factory DailyReport.empty() {
    final newDay = MyUtils.getDateAtMidnight(DateTime.now());
    return DailyReport(id: -1, date: newDay, steps: 0, distance: 0, activeTime: 0, calories: 0);
  }

  factory DailyReport.fromDate(DateTime date) {
    final empty = DailyReport.empty()
    ..date = date;
    return empty;
  }

  factory DailyReport.fromSqlite(Map<String, dynamic> map) {
    final goal = DailyGoal.empty()
    ..id = map[DailyReportFields.goalId];
    return DailyReport(
      id: map[DailyReportFields.id],
      date: MyUtils.getDateFromSqlFormat(map[DailyReportFields.date]),
      steps: map[DailyReportFields.steps],
      distance: map[DailyReportFields.distance],
      activeTime: map[DailyReportFields.activeTime] ?? 0,
      calories: map[DailyReportFields.calories],
      goal: goal,
    );
  }

  Map<String, dynamic> toSqlite() {
    return {
      DailyReportFields.date: MyUtils.getDateAsSqlFormat(date),
      DailyReportFields.steps: steps,
      DailyReportFields.distance: distance,
      DailyReportFields.activeTime: activeTime,
      DailyReportFields.calories: calories,
      DailyReportFields.goalId: goal.id,
    };
  }

  @override
  String toString() {
    return "{id: $id, date: $date, steps: $steps, distance: $distance, activeTime: $activeTime, calories: $calories, goalId: ${goal.id}}";
  }
}
