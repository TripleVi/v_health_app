import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/enum/activity_tracking.dart';
import '../../../core/resources/style.dart';
import '../../../core/utilities/utils.dart';
import '../bloc/activity_tracking_bloc.dart';
import 'time_counter.dart';

class MetricsPage extends StatelessWidget {
  final TrackingParams trackingParams;
  final Stream<int> timeStream;
  final Widget targetWidget;

  const MetricsPage({
    super.key,
    required this.trackingParams,
    required this.timeStream,
    required this.targetWidget,
  });

  List<Widget> _processMetrics(TrackingParams params) {
    final metricsWidgets = <Widget>[];
    metricsWidgets.add(TimeCounter(
      timeStream: timeStream,
      builder: (secondsElapsed) {
        return _metricsWidget(
          txtName: "Duration",
          txtValue: MyUtils.getFormattedDuration(secondsElapsed),
        );
      },
    ));
    final distanceMap = MyUtils.getFormattedDistance(params.distance);
    metricsWidgets.add(_metricsWidget(
      txtName: "Distance",
      txtValue: distanceMap["value"],
      txtUnit: distanceMap["unit"],
    ));
    final speedMap = MyUtils.getFormattedSpeed(params.speed);
    metricsWidgets.add(_metricsWidget(
      txtName: "Speed",
      txtValue: speedMap["value"],
      txtUnit: speedMap["unit"],
    ));
    final avgSpeedMap = MyUtils.getFormattedSpeed(params.avgSpeed);
    metricsWidgets.add(_metricsWidget(
      txtName: "Avg. speed",
      txtValue: avgSpeedMap["value"],
      txtUnit: avgSpeedMap["unit"],
    ));
    final paceMap = MyUtils.getFormattedPace(params.speed);
    metricsWidgets.add(_metricsWidget(
      txtName: "Pace",
      txtValue: paceMap["value"],
      txtUnit: paceMap["unit"],
    ));
    final avgPaceMap = MyUtils.getFormattedPace(params.avgSpeed);
    metricsWidgets.add(_metricsWidget(
      txtName: "Avg. pace",
      txtValue: avgPaceMap["value"],
      txtUnit: avgPaceMap["unit"],
    ));
    final avgCaloriesMap = MyUtils.getFormattedCalories(params.calories);
    metricsWidgets.add(_metricsWidget(
      txtName: "Calories burnt",
      txtValue: avgCaloriesMap["value"],
      txtUnit: avgCaloriesMap["unit"],
    ));

    if(params.selectedTarget.isCalories) {
      metricsWidgets.removeLast();
    }else if(params.selectedTarget.isDistance) {
      metricsWidgets.removeAt(1);
    }else {
      metricsWidgets.removeAt(0);
    }

    return metricsWidgets;
  }

  Widget _metricsWidget({
    String? txtName,
    TextStyle? nameStyle,
    Widget? name,
    String? txtValue,
    TextStyle? valueStyle,
    Widget? value,
    String? txtUnit,
    TextStyle? unitStyle,
    Widget? unit,
  }) {
    assert(txtName != null || name != null);
    assert(txtValue != null || value != null);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        name ?? Text(
          txtName!, 
          style: nameStyle ?? AppStyle.caption1(),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            value ?? Text(
              "${txtValue!} ", 
              style: valueStyle ?? AppStyle.heading3(),
            ),
            unit ?? Text(
              txtUnit ?? "",
              style: unitStyle ?? AppStyle.heading5(),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.all(12.0),
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        color: AppStyle.surfaceColor,
        borderRadius: BorderRadius.circular(AppStyle.borderRadius),
      ),
      child: Column(
        children: [
          targetWidget,
          const SizedBox(height: 32.0),
          Expanded(
            child: GridView.count(
              shrinkWrap: false,
              primary: false,
              childAspectRatio: 1.0,
              crossAxisCount: 2,
              children: _processMetrics(trackingParams),
            ),
          ),
        ],
      ),
    );
  }
}