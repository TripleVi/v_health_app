import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:v_health/core/enum/bottom_navbar.dart";

import "../../../core/utilities/utils.dart";
import "../../../data/repositories/daily_report_repo.dart";
import "../../../domain/entities/daily_report.dart";
import "../../site/bloc/site_bloc.dart";

part "statistics_state.dart";

class StatisticsCubit extends Cubit<StatisticsState> {
  final BuildContext context;
  Timer? timer;

  StatisticsCubit(this.context) : super(StatisticsLoading()) {
    _fetchData();
    initTimer();
  }

  Future<void> _fetchData() async {
    final repo = DailyReportRepo();
    final reports = await repo.fetchRecentReports(DateTime.now(), 7);
    var achieved = 0;
    for (var i = 0; i < 6; i++) {
      reports[i].steps = MyUtils.generateInt(8000);
      reports[i].activeTime = MyUtils.generateInt(100);
      reports[i].calories = MyUtils.generateInt(600)*1.0;

      if(reports[i].steps >= reports[i].goal.steps 
          && reports[i].activeTime >= reports[i].goal.activeTime 
          && reports[i].calories >= reports[i].goal.calories) {
        achieved++;
      }
    }
    emit(StatisticsLoaded(
      today: reports.last,
      recentReports: reports,
      goalsAchieved: achieved,
    ));
  }

  void initTimer() {
    timer = Timer.periodic(const Duration(seconds: 16), (_) async {
      final tap = context.read<SiteBloc>().currentTab();
      if(tap.isStatistics) {
        final repo = DailyReportRepo();
        final curtState = state as StatisticsLoaded;
        final newR = await repo.fetchTodayReport();
        final oldR = curtState.today;
        if(newR.steps > oldR.steps) {
          curtState.recentReports.last = newR;
          emit(curtState.copyWith(today: newR));
        }
      }
    });
  }

  @override
  Future<void> close() async {
    super.close();
    timer?.cancel();
  }
}
