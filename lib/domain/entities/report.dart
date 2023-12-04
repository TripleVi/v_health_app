// ignore_for_file: non_constant_identifier_names

import '../../core/utilities/utils.dart';
import '../../data/sources/table_attributes.dart';

class Report {
  String rid;
  String date;
  int hour;
  int steps;
  double distance;
  int stair;
  int calories;

  Report({
    required this.rid, 
    required this.date, 
    required this.hour, 
    required this.steps, 
    required this.distance, 
    required this.stair, 
    required this.calories,
  });

  factory Report.empty() {
    return Report(rid: "", date: MyUtils.getCurrentDate(), hour: 0, steps: 0, distance: 0.0, stair: 0, calories: 0);
  }

  // Report.before_i_days(String startDate, int i) {
  //   date = MyUtils.get_date_subtracted_by_i(startDate, i);
  // }

  // Report.atDate(this.date, this.hour);

  @override
  String toString() {
    return "{id: $rid, date: $date, hour: $hour, steps: $steps, distance: $distance, stair: $stair, calories: $calories}";
  }
}
