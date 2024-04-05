import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../core/resources/style.dart';

class MetricsProgress extends StatelessWidget {
  final double stepsPercent;
  final double durationPercent;
  final double caloriesPercent;

  const MetricsProgress({
    super.key, 
    required this.stepsPercent, 
    required this.durationPercent,
    required this.caloriesPercent,
  });

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 12.5,
      animation: true,
      animationDuration: 1200,
      lineWidth: 2.5,
      percent: stepsPercent,
      center: CircularPercentIndicator(
        radius: 9,
        animation: true,
        animationDuration: 1200,
        lineWidth: 2.5,
        percent: durationPercent,
        center: CircularPercentIndicator(
          radius: 5.5,
          animation: true,
          animationDuration: 1200,
          lineWidth: 2.5,
          percent: caloriesPercent,
          circularStrokeCap: CircularStrokeCap.round,
          backgroundColor: AppStyle.calorieColor.withOpacity(0.2),
          progressColor: AppStyle.calorieColor,
        ),
        circularStrokeCap: CircularStrokeCap.round,
        backgroundColor: AppStyle.timeColor.withOpacity(0.2),
        progressColor: AppStyle.timeColor,
      ),
      circularStrokeCap: CircularStrokeCap.round,
      backgroundColor: AppStyle.stepColor.withOpacity(0.2),
      progressColor: AppStyle.stepColor,
    );
  }
}