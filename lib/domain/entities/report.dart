import '../../core/utilities/utils.dart';

class Report {
  int rid;
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
    return Report(rid: -1, date: MyUtils.getCurrentDate(), hour: 0, steps: 0, distance: 0.0, stair: 0, calories: 0);
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(rid: map["rid"], date: map["date"], hour: map["hour"], steps: map["steps"], distance: map["distance"], stair: map["stair"], calories: map["calories"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "date": date, "hour": hour, "steps": steps, "distance": distance, "stair": stair, "calories": calories
    };
  }

  @override
  String toString() {
    return "{id: $rid, date: $date, hour: $hour, steps: $steps, distance: $distance, stair: $stair, calories: $calories}";
  }
}
