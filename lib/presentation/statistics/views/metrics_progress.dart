import "package:flutter/material.dart";
import "package:percent_indicator/percent_indicator.dart";

import "../../../core/resources/style.dart";

class MetricsProgress {
  final double stepPercent;
  final double durationPercent;
  final double caloriePercent;

  const MetricsProgress({
    required this.stepPercent, 
    required this.durationPercent,
    required this.caloriePercent,
  });

  Widget get big {
    return CircularPercentIndicator(
      radius: 60.0,
      animation: true,
      animationDuration: 1200,
      lineWidth: 12.0,
      percent: stepPercent,
      center: CircularPercentIndicator(
        radius: 46.0,
        animation: true,
        animationDuration: 1200,
        lineWidth: 12.0,
        percent: durationPercent,
        center: CircularPercentIndicator(
          radius: 32.0,
          animation: true,
          animationDuration: 1200,
          lineWidth: 12.0,
          percent: caloriePercent,
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

  Widget small([bool animation = true]) {
    return CircularPercentIndicator(
      radius: 12.5,
      animation: animation,
      animationDuration: 1200,
      lineWidth: 2.5,
      percent: stepPercent,
      center: CircularPercentIndicator(
        radius: 9,
        animation: animation,
        animationDuration: 1200,
        lineWidth: 2.5,
        percent: durationPercent,
        center: CircularPercentIndicator(
          radius: 5.5,
          animation: animation,
          animationDuration: 1200,
          lineWidth: 2.5,
          percent: caloriePercent,
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