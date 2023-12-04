import 'package:flutter/material.dart';

import 'activity_tracking.dart';

class ActivityCategory {
  ActivityCategory._();

  static const Map<ActivityItem, String> names = {
    ActivityItem.walking: "Walking",
    ActivityItem.running: "Running",
    ActivityItem.cycling: 'Cycling',
  };

  static const Map<ActivityItem, int> values = {
    ActivityItem.standing: 0,
    ActivityItem.walking: 1,
    ActivityItem.running: 2,
    ActivityItem.cycling: 3,
    ActivityItem.unknown: 4,
  };

  static const Map<ActivityItem, Color> lineColors = {
    ActivityItem.walking: Colors.orange,
    ActivityItem.running: Colors.red,
    ActivityItem.cycling: Colors.yellow,
    ActivityItem.standing: Colors.grey,
  };

  static const Map<ActivityItem, String> svgPaths = {
    ActivityItem.walking: "assets/images/activities/walking.svg",
    ActivityItem.running: "assets/images/activities/running.svg",
    ActivityItem.cycling: "assets/images/activities/cycling.svg",
  };
}