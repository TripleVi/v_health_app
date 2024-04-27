part of "daily_activities_cubit.dart";

@immutable
sealed class DailyActivitiesState {}

final class DailyActivitiesLoading extends DailyActivitiesState {}

final class DailyActivitiesLoaded extends DailyActivitiesState {
  final DailyReport report;
  final TimeType timeType;
  final List<int> hourlySteps;
  final List<int> hourlyActiveTime;
  final List<int> hourlyCalories;
  final int maxStepsAxis;
  final int maxActiveTimeAxis;
  final int maxCaloriesAxis;
  final List<WorkoutData> data;

  DailyActivitiesLoaded({
    required this.report,
    this.timeType = TimeType.day,
    this.hourlySteps = const [],
    this.hourlyActiveTime = const [],
    this.hourlyCalories = const [],
    required this.maxStepsAxis,
    required this.maxActiveTimeAxis,
    required this.maxCaloriesAxis,
    required this.data,
  });
}

final class WeeklyActivitiesLoaded extends DailyActivitiesState {
  final DateTime startOfWeek;
  final DateTime endOfWeek;
  final TimeType timeType;
  final int stepsTarget;
  final int activeTimeTarget;
  final int caloriesTarget;
  final int totalStepsTarget;
  final int totalActiveTimeTarget;
  final int totalCaloriesTarget;
  final int goalsAchieved;
  final List<int> dailySteps;
  final List<int> dailyActiveTime;
  final List<int> dailyCalories;
  final int maxStepsAxis;
  final int maxActiveTimeAxis;
  final int maxCaloriesAxis;

  WeeklyActivitiesLoaded({
    required this.startOfWeek,
    required this.endOfWeek,
    this.timeType = TimeType.week,
    required this.stepsTarget,
    required this.activeTimeTarget,
    required this.caloriesTarget,
    required this.totalStepsTarget,
    required this.totalActiveTimeTarget,
    required this.totalCaloriesTarget,
    required this.goalsAchieved,
    required this.dailySteps,
    required this.dailyActiveTime,
    required this.dailyCalories,
    required this.maxStepsAxis,
    required this.maxActiveTimeAxis,
    required this.maxCaloriesAxis,
  });
}

final class MonthlyActivitiesLoaded extends DailyActivitiesState {
  final DateTime startOfMonth;
  final DateTime endOfMonth;
  final TimeType timeType;
  final int stepsTarget;
  final int activeTimeTarget;
  final int caloriesTarget;
  final int goalsAchieved;
  final List<int> dailySteps;
  final List<int> dailyActiveTime;
  final List<int> dailyCalories;
  final int maxStepsAxis;
  final int maxActiveTimeAxis;
  final int maxCaloriesAxis;

  MonthlyActivitiesLoaded({
    required this.startOfMonth,
    required this.endOfMonth,
    this.timeType = TimeType.month,
    required this.stepsTarget,
    required this.activeTimeTarget,
    required this.caloriesTarget,
    required this.goalsAchieved,
    required this.dailySteps,
    required this.dailyActiveTime,
    required this.dailyCalories,
    required this.maxStepsAxis,
    required this.maxActiveTimeAxis,
    required this.maxCaloriesAxis,
  });
}

final class YearlyActivitiesLoaded extends DailyActivitiesState {
  final int year;
  final TimeType timeType;
  final int goalsAchieved;
  final List<int> monthlySteps;
  final List<int> monthlyActiveTime;
  final List<int> monthlyCalories;
  final int maxStepsAxis;
  final int maxActiveTimeAxis;
  final int maxCaloriesAxis;

  YearlyActivitiesLoaded({
    required this.year,
    this.timeType = TimeType.year,
    required this.goalsAchieved,
    required this.monthlySteps,
    required this.monthlyActiveTime,
    required this.monthlyCalories,
    required this.maxStepsAxis,
    required this.maxActiveTimeAxis,
    required this.maxCaloriesAxis,
  });
}
