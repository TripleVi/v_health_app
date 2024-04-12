import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:syncfusion_flutter_datepicker/datepicker.dart";

import "../../../../../core/utilities/utils.dart";
import "../../../../../data/repositories/daily_report_repo.dart";
import "../../../../../domain/entities/daily_report.dart";
import "../calendar_page.dart";

part "calendar_state.dart";

class CalendarCubit extends Cubit<CalendarState> {
  final List<List<DailyReport>> monthlyReports = [];
  GlobalKey<CalendarHeaderState>? headerKey;

  CalendarCubit() : super(CalendarStateLoading()) {
    fetchData(DateTime.now()).then((_) {
      emit(CalendarStateLoaded(
        controller: DateRangePickerController(),
        reports: monthlyReports,
      ));
    });
  }

  void setHeaderKey(GlobalKey<CalendarHeaderState> headerKey) {
    this.headerKey = headerKey;
  }

  void onViewChanged(DateTime startDate) {
    final diff = MyUtils
        .monthsDifference(startDate, monthlyReports.last.last.date);
    if(diff == 4) {
      fetchData(MyUtils.subtractMonth(monthlyReports.last.last.date, 1));
    }
    final index = MyUtils
        .monthsDifference(monthlyReports.first.first.date, startDate);
    final reports = monthlyReports[index];
    var steps = 0, minutes = 0, calories = 0, goalsAchieved = 0;
    for (var r in reports) {
      steps += r.steps;
      minutes += r.activeTime;
      calories += calories;
      if(r.steps >= r.goal.steps 
          && r.activeTime >= r.goal.activeTime 
          && r.calories >= r.goal.calories) {
        goalsAchieved++;
      } 
    }
    headerKey!.currentState!.updateStateHelper(
      title: MyUtils.getFormattedMonth(startDate),
      daysInMonth: DateUtils.getDaysInMonth(startDate.year, startDate.month),
      steps: steps,
      minutes: minutes,
      calories: calories,
      goalsAchieved: goalsAchieved,
    );
  }

  Future<void> fetchData(DateTime startDate) async {
    final repo = DailyReportRepo();
    for (var i = 0; i < 10; i++) {
      final date = MyUtils.subtractMonth(startDate, i);
      final reports = await repo.fetchReportsByMonth(date);
      //! mockup data
      for (var i = 0; i < reports.length; i++) {
        final monthlySteps = MyUtils.generateIntList(reports.length, 8000);
        final monthlyActiveTime = MyUtils.generateIntList(reports.length, 400);
        final monthlyCalories = MyUtils.generateIntList(reports.length, 800);
        reports[i].steps = monthlySteps[i];
        reports[i].activeTime = monthlyActiveTime[i];
        reports[i].calories = monthlyCalories[i];
      }
      monthlyReports.add(reports);
    }
  }

  void moveForward() {
    (state as CalendarStateLoaded).controller.forward!();
  }

  void moveBackward() {
    (state as CalendarStateLoaded).controller.backward!();
  }

  @override
  Future<void> close() async {
    super.close();
    (state as CalendarStateLoaded).controller.dispose();
  }
}
