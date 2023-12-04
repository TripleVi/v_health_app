// ignore_for_file: non_constant_identifier_names

import '../../core/utilities/utils.dart';
import '../../data/sources/table_attributes.dart';

class DailySummary {
  String date = MyUtils.getCurrentDateAsSqlFormat();
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

  @override
  String toString() {
    return "{date: $date, steps: $steps, distance: $distance, stair: $stair, calories: $calories}";
  }

  DailySummary.fromMap(Map<String, dynamic> json)
      : date = json[DailySummaryFields.date],
        steps = json[DailySummaryFields.steps],
        distance = json[DailySummaryFields.distance],
        stair = json[DailySummaryFields.stair],
        calories = json[DailySummaryFields.calories];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      DailySummaryFields.date: date,
      DailySummaryFields.steps: steps,
      DailySummaryFields.distance: distance,
      DailySummaryFields.stair: stair,
      DailySummaryFields.calories: calories,
    };
  }
}
