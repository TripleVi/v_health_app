import "dart:math" as math;

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:matrix2d/matrix2d.dart";

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
    _fetchData();
  }

  List<int> mockupStepsList(int length) {
    return List.generate(length, (index) {
      final rng = math.Random();
      return rng.nextInt(1000);
    });
  }

  List<int> mockupActiveTimeList(int length) {
    return List.generate(length, (index) {
      final rng = math.Random();
      return rng.nextInt(370)+30;
    });
  }

  List<int> mockupCaloriesList(int length) {
    return List.generate(length, (index) {
      final rng = math.Random();
      return rng.nextInt(5000)+500;
    });
  }

  Future<void> _fetchData() async {
    final dRepo = DailyReportRepo();
    // final hRepo = HourlyReportRepo();
    final report = await dRepo.fetchTodayReport();
    // final hourlyReports = await hRepo.fetchReportsByDate(report.id);
    // final hourlySteps = hourlyReports.map((e) => e.steps).toList();
    final hourlySteps = List.generate(24, (index) {
      final rng = math.Random();
      return rng.nextInt(1000);
    });
    final hourlyActiveTime = List.generate(24, (index) {
      final rng = math.Random();
      return rng.nextInt(370)+30;
    });
    final hourlyCalories = List.generate(24, (index) {
      final rng = math.Random();
      return rng.nextInt(5000)+500;
    });
    final int maxSteps = hourlySteps.max().first;
    final int maxDuration = hourlyActiveTime.max().first;
    final int maxCalories = hourlyCalories.max().first;
    emit(DailyActivitiesLoaded(
      report: report,
      hourlySteps: hourlySteps,
      hourlyActiveTime: hourlyActiveTime,
      hourlyCalories: hourlyCalories,
      maxStepsAxis: math
          .max(report.goal.steps+1000, (maxSteps~/5)*5+1000),
      maxActiveTimeAxis: math
          .max(report.goal.activeTime+60, (maxDuration~/5)*5+1000),
      maxCaloriesAxis: math
          .max(report.goal.calories+1000, (maxCalories~/5)*5+1000),
    ));

  }

  void viewByDay() {
    emit((state as DailyActivitiesLoaded)
        .copyWith(timeType: TimeType.day));
  }

  void viewByWeek() {
    emit((state as DailyActivitiesLoaded)
        .copyWith(timeType: TimeType.week));
  }

  void viewByMonth() {
    emit((state as DailyActivitiesLoaded)
        .copyWith(timeType: TimeType.month));
  }

  void viewByYear() {
    emit((state as DailyActivitiesLoaded)
        .copyWith(timeType: TimeType.year));
  }

  Future<void> nextDay() async {
    isProcessing = true;
    final current = (state as DailyActivitiesLoaded).report.date;
    final dRepo = DailyReportRepo();
    final hRepo = HourlyReportRepo();
    final nextDay = current.add(const Duration(days: 1));
    final report = await dRepo.fetchDailyReport(nextDay);
    final hourlyReports = await hRepo.fetchReportsByDate(report.id);
    // emit(DailyActivitiesLoaded(
    //   report: report,
    //   hourlyReports: hourlyReports,
    // ));
    // isProcessing = false;
  }

  Future<void> previousDay() async {
    isProcessing = true;
    final current = (state as DailyActivitiesLoaded).report.date;
    final dRepo = DailyReportRepo();
    final hRepo = HourlyReportRepo();
    final prevDay = current.subtract(const Duration(days: 1));
    final report = await dRepo.fetchDailyReport(prevDay);
    final hourlyReports = await hRepo.fetchReportsByDate(report.id);
    // emit(DailyActivitiesLoaded(
    //   report: report,
    //   hourlyReports: hourlyReports,
    // ));
    // isProcessing = false;
  }

  Future<void> fetchWeeklyActivitiesData() async {
    final dRepo = DailyReportRepo();
    final today = DateTime.now();
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    final reports = await dRepo.fetchReportsByWeek(startOfWeek);
    var totalSteps = 0, totalActiveTime = 0, totalCalories = 0;
    var stepsTarget = 0, activeTimeTarget = 0, caloriesTarget = 0;
    List<int> 
        dailySteps = [], dailyActiveTime = [], dailyCalories = [];
    for (var r in reports) {
      totalSteps += r.steps;
      totalActiveTime += r.activeTime;
      totalCalories += r.calories;
      stepsTarget += r.goal.steps;
      activeTimeTarget += r.goal.activeTime;
      caloriesTarget += r.goal.calories;
      dailySteps.add(r.steps);
      dailyActiveTime.add(r.activeTime);
      dailyCalories.add(r.calories);
    }
    dailySteps = List.generate(7, (index) {
      final rng = math.Random();
      return rng.nextInt(1000);
    });
    dailyActiveTime = List.generate(7, (index) {
      final rng = math.Random();
      return rng.nextInt(370)+30;
    });
    dailyCalories = List.generate(7, (index) {
      final rng = math.Random();
      return rng.nextInt(5000)+500;
    });
    final int maxSteps = dailySteps.max().first;
    final int maxDuration = dailyActiveTime.max().first;
    final int maxCalories = dailyCalories.max().first;

    emit(WeeklyActivitiesLoaded(
      startOfWeek: startOfWeek,
      endOfWeek: endOfWeek,
      steps: totalSteps,
      activeTime: totalActiveTime,
      calories: totalCalories,
      stepsTarget: stepsTarget,
      activeTimeTarget: activeTimeTarget,
      caloriesTarget: caloriesTarget,
      dailySteps: dailySteps,
      dailyActiveTime: dailyActiveTime,
      dailyCalories: dailyCalories,
      maxStepsAxis: math.max(stepsTarget+1000, (maxSteps~/5)*5+1000),
      maxActiveTimeAxis: math.max(activeTimeTarget+60, (maxDuration~/5)*5+1000),
      maxCaloriesAxis: math.max(caloriesTarget+1000, (maxCalories~/5)*5+1000),
    ));
  }

  Future<void> fetchMonthlyActivitiesData() async {
    final today = DateTime.now();
    final startOfMonth = DateTime(today.year, today.month);
    final dRepo = DailyReportRepo();
    final reports = await dRepo.fetchReportsByMonth(startOfMonth);
    var totalSteps = 0, totalActiveTime = 0, totalCalories = 0;
    var stepsTarget = 0, activeTimeTarget = 0, caloriesTarget = 0;
    List<int> 
        dailySteps = [], dailyActiveTime = [], dailyCalories = [];
    for (var r in reports) {
      totalSteps += r.steps;
      totalActiveTime += r.activeTime;
      totalCalories += r.calories;
      stepsTarget += r.goal.steps;
      activeTimeTarget += r.goal.activeTime;
      caloriesTarget += r.goal.calories;
      dailySteps.add(r.steps);
      dailyActiveTime.add(r.activeTime);
      dailyCalories.add(r.calories);
    }
    dailySteps = List.generate(7, (index) {
      final rng = math.Random();
      return rng.nextInt(1000);
    });
    dailyActiveTime = List.generate(7, (index) {
      final rng = math.Random();
      return rng.nextInt(370)+30;
    });
    dailyCalories = List.generate(7, (index) {
      final rng = math.Random();
      return rng.nextInt(5000)+500;
    });
    final int maxSteps = dailySteps.max().first;
    final int maxDuration = dailyActiveTime.max().first;
    final int maxCalories = dailyCalories.max().first;

    emit(MonthlyActivitiesLoaded(
      startOfMonth: startOfMonth,
      steps: totalSteps,
      activeTime: totalActiveTime,
      calories: totalCalories,
      dailySteps: dailySteps,
      dailyActiveTime: dailyActiveTime,
      dailyCalories: dailyCalories,
      maxStepsAxis: math.max(stepsTarget+1000, (maxSteps~/5)*5+1000),
      maxActiveTimeAxis: math.max(activeTimeTarget+60, (maxDuration~/5)*5+1000),
      maxCaloriesAxis: math.max(caloriesTarget+1000, (maxCalories~/5)*5+1000),
    ));
  }
}
