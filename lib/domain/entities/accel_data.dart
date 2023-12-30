import '../../core/utilities/utils.dart';
import '../../data/sources/table_attributes.dart';

class AccelData {
  double x = 0.0;
  double y = 0.0;
  double z = 0.0;
  String? activity = "";
  int t = DateTime.now().millisecondsSinceEpoch;
  int hour = DateTime.now().hour;
  int quarter = (DateTime.now().minute / 15).round() + 1;
  String date = MyUtils.getDateAsSqlFormat(DateTime.now());

  AccelData(this.x, this.y, this.z, this.activity);

  // AccelData.fromEvent(UserAccelerometerEvent event) {
  //   x = double.parse(event.x.toStringAsFixed(2));
  //   y = double.parse(event.y.toStringAsFixed(2));
  //   z = double.parse(event.z.toStringAsFixed(2));
  // }

  @override
  String toString() {
    return "t: $t, x: $x; y: $y; z: $z; activity: $activity; hour: $hour; quarter: $quarter; date: $date; ";
  }

  AccelData.fromMap(Map<String, dynamic> json)
      : x = json[AccelDataFields.X],
        y = json[AccelDataFields.Y],
        z = json[AccelDataFields.Z],
        t = json[AccelDataFields.T],
        activity = json[AccelDataFields.Activity],
        hour = json[AccelDataFields.Hour],
        quarter = json[AccelDataFields.Quarter],
        date = json[AccelDataFields.Date];

  Map<String, dynamic> toMap() {
    return {
      'x': x,
      'y': y,
      'z': z,
      't': t,
      'hour': hour,
      'activity': activity,
      'quarter': quarter,
      'date': date,
    };
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      AccelDataFields.X: x,
      AccelDataFields.Y: y,
      AccelDataFields.Z: z,
      AccelDataFields.T: t,
      AccelDataFields.Hour: hour,
      AccelDataFields.Quarter: quarter,
      AccelDataFields.Date: date,
      AccelDataFields.Activity: activity,
    };
  }
}
