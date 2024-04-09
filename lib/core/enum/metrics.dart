import 'package:flutter/material.dart';

import '../resources/style.dart';

enum Metrics {
  speed,
  distance,
  calorie, 
  step,
  time,
  pace,
}

extension MetricsExtension on Metrics {
  String get unit {
    switch (this) {
      case Metrics.speed:
        return "km/h";
      case Metrics.distance:
        return "km";
      case Metrics.calorie:
        return "kcal";
      case Metrics.pace:
        return "/km";
      default:
        return "";
    }
  }

  String get name {
    switch (this) {
      case Metrics.speed:
        return "Speed";
      case Metrics.distance:
        return "Distance";
      case Metrics.step:
        return "Steps";
      case Metrics.time:
        return "Time";
      case Metrics.calorie:
        return "Calories";
      case Metrics.pace:
        return "Pace";
      default:
        return "";
    }
  }

  Color get color {
    switch (this) {
      case Metrics.step:
        return AppStyle.stepColor;
      case Metrics.calorie:
        return AppStyle.calorieColor;
      case Metrics.time:
        return AppStyle.timeColor;
      default:
        return AppStyle.secondaryIconColor;
    }
  }

  String? get assetName {
    switch (this) {
      case Metrics.step:
        return "assets/images/activities/step.svg";
      case Metrics.calorie:
        return "assets/images/activities/calorie.svg";
      case Metrics.time:
        return "assets/images/activities/time.svg";
      default:
        return null;
    }
  }
}