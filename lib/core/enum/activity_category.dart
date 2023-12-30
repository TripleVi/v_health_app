import 'package:flutter/material.dart';

enum ActivityCategory {walking, running, cycling}

extension ActivityCategoryExtension on ActivityCategory {
  bool get isWalking => this == ActivityCategory.walking;
  bool get isRunning => this == ActivityCategory.running;
  bool get isCycling => this == ActivityCategory.cycling;

  String get stringValue {
    switch (this) {
      case ActivityCategory.walking:
        return "Walking";
      case ActivityCategory.running:
        return "Running";
      case ActivityCategory.cycling:
        return "Cycling";
      default:
        return "Unknown";
    }
  }

  Color get lineColors {
    switch (this) {
      case ActivityCategory.walking:
        return Colors.orange;
      case ActivityCategory.running:
        return Colors.red;
      case ActivityCategory.cycling:
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  String get svgPaths {
    switch (this) {
      case ActivityCategory.walking:
        return "assets/images/activities/walking.svg";
      case ActivityCategory.running:
        return "assets/images/activities/running.svg";
      case ActivityCategory.cycling:
        return "assets/images/activities/cycling.svg";
      default:
        return "";
    }
  }
}