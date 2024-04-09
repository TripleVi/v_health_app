import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

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
    emit(StatisticsLoaded(
      stepValue: report.steps,
      stepTarget: report.goal.steps,
      minuteValue: report.activeTime,
      minuteTarget: report.goal.activeTime,
      calorieValue: report.calories ~/ 1000,
      calorieTarget: report.goal.calories,
      recentReports: reports,
    ));
  }
}
