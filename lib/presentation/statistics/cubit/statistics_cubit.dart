import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../core/utilities/utils.dart";
import "../../../data/repositories/daily_report_repo.dart";
import "../../../domain/entities/daily_report.dart";

part "statistics_state.dart";

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit() : super(StatisticsLoading()) {
    _fetchData();
  }

  Future<void> _fetchData() async {
    final repo = DailyReportRepo();
    final report = await repo.fetchTodayReport();
    final reports = await repo.fetchRecentReports(DateTime.now(), 7);
    final dailySteps = MyUtils.generateIntList(7, 8000);
    final dailyActiveTime = MyUtils.generateIntList(7, 400);
    final dailyCalories = MyUtils.generateIntList(7, 800);
    for (var i = 0; i < 7; i++) {
      reports[i].steps = dailySteps[i];
      reports[i].activeTime = dailyActiveTime[i];
      // reports[i].calories = dailyCalories[i];
    }

    emit(StatisticsLoaded(
      stepValue: 2000,
      stepTarget: report.goal.steps,
      minuteValue: 40,
      minuteTarget: report.goal.activeTime,
      // calorieValue: report.calories ~/ 1000,
      calorieValue: 150,
      calorieTarget: report.goal.calories,
      recentReports: reports,
    ));
  }
}
