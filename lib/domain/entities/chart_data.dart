import 'package:flutter/material.dart';

import 'daily_steps.dart';
import 'report.dart';

class ChartData {
  ChartData(this.x, this.y, this.color);
  int x = 0;
  int y = 0;
  Color color = Colors.white;

  ChartData.hourlyDataDistance(Report data) {
    x = data.hour;
    y = data.distance.round();
  }

  ChartData.hourlyDataCalories(Report data) {
    x = data.hour;
    y = data.calories;
  }

  ChartData.hourlyData(Report data) {
    x = data.hour;
    y = data.steps;
  }

  ChartData.hourlyDataMockup(int hour, int steps) {
    x = hour;
    y = steps;
  }

  ChartData.dailySummary(int index, DailySummary data) {
    x = index;
    y = data.steps;
  }

  @override
  String toString() {
    return "{x: $x, y: $y}";
  }
}
