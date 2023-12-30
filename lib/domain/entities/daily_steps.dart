// ignore_for_file: non_constant_identifier_names

import '../../core/utilities/utils.dart';
import '../../data/sources/table_attributes.dart';

class DailySummary {
  String date = MyUtils.getDateAsSqlFormat(DateTime.now());
  int steps = 0;
  double distance = 0.0;
  int stair = 0;
  int calories = 0;

  DailySummary(this.date, this.steps, this.distance, this.stair, this.calories);

  DailySummary.newReport(
      this.date, this.steps, this.distance, this.stair, this.calories);

  DailySummary.fromDate(this.date);

  DailySummary.before_i_days(String startDate, int i) {
    date = MyUtils.get_date_subtracted_by_i(startDate, i);
  }

  DailySummary.empty();

  factory DailySummary.fromMap(Map<String, dynamic> map) {
    return DailySummary(
      map[DailySummaryFields.date], map[DailySummaryFields.steps], map[DailySummaryFields.distance], map[DailySummaryFields.stair], map[DailySummaryFields.calories]
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      DailySummaryFields.date: date,
      DailySummaryFields.steps: steps,
      DailySummaryFields.distance: distance,
      DailySummaryFields.stair: stair,
      DailySummaryFields.calories: calories,
    };
  }

  @override
  String toString() {
    return "{date: $date, steps: $steps, distance: $distance, stair: $stair, calories: $calories}";
  }
}
