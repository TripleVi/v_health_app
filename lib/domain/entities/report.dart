import '../../data/sources/table_attributes.dart';
import 'daily_report.dart';

class Report {
  int id;
  int hour;
  int steps;
  double distance;
  int calories;
  DailyReport day;


  Report({
    required this.id, 
    required this.hour, 
    required this.steps, 
    required this.distance,
    required this.calories,
    DailyReport? day,
  })
  : day = day ?? DailyReport.empty();

  factory Report.empty() {
    return Report(id: -1, hour: 0, steps: 0, distance: 0.0, calories: 0);
  }

  factory Report.fromHour(int hour) {
    final empty = Report.empty()
    ..hour = hour;
    return empty;
  }

  factory Report.fromSqlite(Map<String, dynamic> map) {
    final day = DailyReport.empty()
    ..id = map[HourlyReportFields.dayId];
    return Report(
      id: map[HourlyReportFields.id], 
      hour: map[HourlyReportFields.hour], 
      steps: map[HourlyReportFields.steps], 
      distance: map[HourlyReportFields.distance], 
      calories: map[HourlyReportFields.calories],
      day: day,
    );
  }

  Map<String, dynamic> toSqlite() {
    return {
      HourlyReportFields.hour: hour, 
      HourlyReportFields.steps: steps, 
      HourlyReportFields.distance: distance,
      HourlyReportFields.calories: calories,
      HourlyReportFields.dayId: day.id,
    };
  }

  @override
  String toString() {
    return "{id: $id, hour: $hour, steps: $steps, distance: $distance, calories: $calories, dayId: ${day.id}}";
  }
}
