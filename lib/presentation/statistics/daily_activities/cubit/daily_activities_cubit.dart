import "dart:math" as math;

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:matrix2d/matrix2d.dart";

import "../../../../core/utilities/utils.dart";
import "../../../../data/repositories/daily_report_repo.dart";
import "../../../../data/repositories/hourly_report_repo.dart";
import "../../../../domain/entities/daily_report.dart";
import "../../../../domain/entities/report.dart";

part "daily_activities_state.dart";

enum TimeType {day, week, month, year}

extension TimeTypeExtension on TimeType {
  bool get isDay => this == TimeType.day;
  bool get isWeek => this == TimeType.week;
  bool get isMonth => this == TimeType.month;
  bool get isYear => this == TimeType.year;
}

class DailyActivitiesCubit extends Cubit<DailyActivitiesState> {
  var isProcessing = false;

  DailyActivitiesCubit() : super(DailyActivitiesLoading()) {
    _fetchHourlyData(DateTime.now());
  }

  Future<void> _fetchHourlyData(DateTime date) async {
    final dRepo = DailyReportRepo();
    // final hRepo = HourlyReportRepo();
    final report = await dRepo.fetchDailyReport(date);
    // final hourlyReports = await hRepo.fetchReportsByDate(report.id);
    // final hourlySteps = hourlyReports.map((e) => e.steps).toList();
    final hourlySteps = MyUtils.generateIntList(24, 400);
    final hourlyActiveTime = MyUtils.generateIntList(24, 20);
    final hourlyCalories = MyUtils.generateIntList(24, 25);
    final maxSteps = hourlySteps.max().first;
    final maxDuration = hourlyActiveTime.max().first;
    final maxCalories = hourlyCalories.max().first;
    report.steps = hourlySteps.sum;
    report.activeTime = hourlyActiveTime.sum;
    report.calories = hourlyCalories.sum;
    emit(DailyActivitiesLoaded(
      report: report,
      hourlySteps: hourlySteps,
      hourlyActiveTime: hourlyActiveTime,
      hourlyCalories: hourlyCalories,
      maxStepsAxis: MyUtils.roundToNearestHundred(maxSteps),
      maxActiveTimeAxis: MyUtils.roundToNearestHundred(maxDuration),
      maxCaloriesAxis: MyUtils.roundToNearestHundred(maxCalories),
    ));
  }

  Future<void> onDateSelected(DateTime? date) async {
    // if(isProcessing) return;
    // isProcessing = true;
    final currentDate = (state as DailyActivitiesLoaded).report.date;
    if(date == null || DateUtils.isSameDay(date, (currentDate))) return;
    await _fetchHourlyData(date);
    // isProcessing = false;
  }

  Future<void> onMonthSelected(DateTime? startDate) async {
    // if(isProcessing) return;
    // isProcessing = true;
    final currentDate = (state as MonthlyActivitiesLoaded).startOfMonth;
    if(startDate == null || DateUtils.isSameMonth(currentDate, startDate)) return;
    await fetchDataByMonth(startDate);
    // isProcessing = false;
  }

  void viewByDay() {
    _fetchHourlyData(DateTime.now());
  }

  void viewByWeek() {
    fetchDataByWeek(DateTime.now());
  }

  void viewByMonth() {
    fetchDataByMonth(DateTime.now());
  }

  void viewByYear() {
    fetchDataByYear(DateTime.now().year);
  }

  Future<void> nextDay() async {
    if(isProcessing) return;
    isProcessing = true;
    final nextDay = (state as DailyActivitiesLoaded)
        .report.date.add(const Duration(days: 1));
    await _fetchHourlyData(nextDay);
    isProcessing = false;
  }

  Future<void> prevDay() async {
    if(isProcessing) return;
    isProcessing = true;
    final prevDay = (state as DailyActivitiesLoaded)
        .report.date.subtract(const Duration(days: 1));
    await _fetchHourlyData(prevDay);
    isProcessing = false;
  }

  Future<void> nextWeek() async {
    if(isProcessing) return;
    isProcessing = true;
    final nextWeek = (state as WeeklyActivitiesLoaded)
        .startOfWeek.add(const Duration(days: 7));
    await fetchDataByWeek(nextWeek);
    isProcessing = false;
  }

  Future<void> prevWeek() async {
    if(isProcessing) return;
    isProcessing = true;
    final prevWeek = (state as WeeklyActivitiesLoaded)
        .startOfWeek.subtract(const Duration(days: 7));
    await fetchDataByWeek(prevWeek);
    isProcessing = false;
  }

  Future<void> nextMonth() async {
    if(isProcessing) return;
    isProcessing = true;
    final selected = (state as MonthlyActivitiesLoaded).startOfMonth;
    final nextMonth = DateTime(selected.year, selected.month+1);
    await fetchDataByMonth(nextMonth);
    isProcessing = false;
  }

  Future<void> prevMonth() async {
    if(isProcessing) return;
    isProcessing = true;
    final selected = (state as MonthlyActivitiesLoaded).startOfMonth;
    final prevMonth = DateTime(selected.year, selected.month-1);
    await fetchDataByMonth(prevMonth);
    isProcessing = false;
  }

  Future<void> nextYear() async {
    if(isProcessing) return;
    isProcessing = true;
    final selected = (state as YearlyActivitiesLoaded).year;
    await fetchDataByYear(selected+1);
    isProcessing = false;
  }

  Future<void> prevYear() async {
    if(isProcessing) return;
    isProcessing = true;
    final selected = (state as YearlyActivitiesLoaded).year;
    await fetchDataByYear(selected-1);
    isProcessing = false;
  }

  Future<void> fetchDataByWeek(DateTime date) async {
    final dRepo = DailyReportRepo();
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    final reports = await dRepo.fetchReportsByWeek(startOfWeek);
    var totalStepsTarget = 0, totalActiveTimeTarget = 0, totalCaloriesTarget = 0;
    var goalsAchieved = 0;
    List<int> 
        dailySteps = [], dailyActiveTime = [], dailyCalories = [];
    for (var r in reports) {
      totalStepsTarget += r.goal.steps;
      totalActiveTimeTarget += r.goal.activeTime;
      totalCaloriesTarget += r.goal.calories;
      dailySteps.add(r.steps);
      dailyActiveTime.add(r.activeTime);
      dailyCalories.add(r.calories);
    }
    //! Mockup data
    dailySteps = MyUtils.generateIntList(7, 8000);
    dailyActiveTime = MyUtils.generateIntList(7, 400);
    dailyCalories = MyUtils.generateIntList(7, 800);
    final int maxSteps = dailySteps.max().first;
    final int maxDuration = dailyActiveTime.max().first;
    final int maxCalories = dailyCalories.max().first;
    for (var i = 0; i < 7; i++) {
      if(dailySteps[i] >= reports[i].goal.steps 
          && dailyActiveTime[i] >= reports[i].goal.activeTime 
          && dailyCalories[i] >= reports[i].goal.calories) {
        goalsAchieved++;
      }
    }
    emit(WeeklyActivitiesLoaded(
      startOfWeek: startOfWeek,
      endOfWeek: endOfWeek,
      stepsTarget: reports.last.goal.steps,
      activeTimeTarget: reports.last.goal.activeTime,
      caloriesTarget: reports.last.goal.calories,
      totalStepsTarget: totalStepsTarget,
      totalActiveTimeTarget: totalActiveTimeTarget,
      totalCaloriesTarget: totalCaloriesTarget,
      goalsAchieved: goalsAchieved,
      dailySteps: dailySteps,
      dailyActiveTime: dailyActiveTime,
      dailyCalories: dailyCalories,
      maxStepsAxis: math.max(reports.last.goal.steps+1000, (maxSteps~/10)*10+1000),
      maxActiveTimeAxis: math.max(reports.last.goal.activeTime+60, (maxDuration~/10)*10+1000),
      maxCaloriesAxis: math.max(reports.last.goal.calories+1000, (maxCalories~/10)*10+1000),
    ));
  }

  Future<void> fetchDataByMonth(DateTime date) async {
    final startOfMonth = DateTime(date.year, date.month);
    final endOfMonth = DateTime(date.year, date.month+1)
        .subtract(const Duration(days: 1));
    final dRepo = DailyReportRepo();
    final reports = await dRepo.fetchReportsByMonth(startOfMonth);
    var goalsAchieved = 0;
    List<int> 
        dailySteps = [], dailyActiveTime = [], dailyCalories = [];
    for (var r in reports) {
      dailySteps.add(r.steps);
      dailyActiveTime.add(r.activeTime);
      dailyCalories.add(r.calories);
    }
    //! Mockup data
    dailySteps = MyUtils.generateIntList(reports.length, 8000);
    dailyActiveTime = MyUtils.generateIntList(reports.length, 400);
    dailyCalories = MyUtils.generateIntList(reports.length, 800);
    final int maxSteps = dailySteps.max().first;
    final int maxDuration = dailyActiveTime.max().first;
    final int maxCalories = dailyCalories.max().first;
    for (var i = 0; i < dailySteps.length; i++) {
      if(dailySteps[i] >= reports[i].goal.steps 
          && dailyActiveTime[i] >= reports[i].goal.activeTime 
          && dailyCalories[i] >= reports[i].goal.calories) {
        goalsAchieved++;
      }
    }
    emit(MonthlyActivitiesLoaded(
      startOfMonth: startOfMonth,
      endOfMonth: endOfMonth,
      stepsTarget: reports.last.goal.steps,
      activeTimeTarget: reports.last.goal.activeTime,
      caloriesTarget: reports.last.goal.calories,
      goalsAchieved: goalsAchieved,
      dailySteps: dailySteps,
      dailyActiveTime: dailyActiveTime,
      dailyCalories: dailyCalories,
      maxStepsAxis: math.max(reports.last.goal.steps+1000, (maxSteps~/10)*10+1000),
      maxActiveTimeAxis: math.max(reports.last.goal.activeTime+60, (maxDuration~/10)*10+1000),
      maxCaloriesAxis: math.max(reports.last.goal.calories+1000, (maxCalories~/10)*10+1000),
    ));
  }

  Future<void> fetchDataByYear(int year) async {
    final dRepo = DailyReportRepo();
    final reports = await dRepo.fetchReportsByYear(year);
    var goalsAchieved = 0;
    List<int> 
        monthlySteps = [], monthlyActiveTime = [], monthlyCalories = [];
    for (var m in reports) {
      int steps = 0, minutes = 0, calories = 0;
      for (var d in m) {
        //! Mockup data
        d.steps = MyUtils.generateInt(8000);
        d.activeTime = MyUtils.generateInt(400);
        d.calories = MyUtils.generateInt(800);
        
        steps += d.steps;
        minutes += d.activeTime;
        calories += d.calories;
        if(d.steps >= d.goal.steps 
          && d.activeTime >= d.goal.activeTime 
          && d.calories >= d.goal.calories) {
          goalsAchieved++;
        }
      }
      monthlySteps.add(steps);
      monthlyActiveTime.add(minutes);
      monthlyCalories.add(calories);
    }
    final int maxSteps = monthlySteps.max().first;
    final int maxDuration = monthlyActiveTime.max().first;
    final int maxCalories = monthlyCalories.max().first;
    emit(YearlyActivitiesLoaded(
      year: year,
      goalsAchieved: goalsAchieved,
      monthlySteps: monthlySteps,
      monthlyActiveTime: monthlyActiveTime,
      monthlyCalories: monthlyCalories,
      maxStepsAxis: (maxSteps~/10)*10+1000,
      maxActiveTimeAxis: (maxDuration~/10)*10+100,
      maxCaloriesAxis: (maxCalories~/10)*10+100,
    ));
  }
}