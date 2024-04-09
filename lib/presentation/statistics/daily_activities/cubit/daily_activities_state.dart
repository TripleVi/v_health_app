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

  DailyActivitiesLoaded({
    required this.report,
    this.timeType = TimeType.day,
    this.hourlySteps = const [],
    this.hourlyActiveTime = const [],
    this.hourlyCalories = const [],
    required this.maxStepsAxis,
    required this.maxActiveTimeAxis,
    required this.maxCaloriesAxis,
  });

  DailyActivitiesLoaded copyWith({
    DailyReport? report,
    TimeType? timeType,
    List<int>? hourlySteps,
    List<int>? hourlyActiveTime,
    List<int>? hourlyCalories,
    int? maxStepsAxis,
    int? maxActiveTimeAxis,
    int? maxCaloriesAxis,
  }) {
    return DailyActivitiesLoaded(
      report: report ?? this.report,
      timeType: timeType ?? this.timeType,
      hourlySteps: hourlySteps ?? this.hourlySteps,
      hourlyActiveTime: hourlyActiveTime ?? this.hourlyActiveTime,
      hourlyCalories: hourlyCalories ?? this.hourlyCalories,
      maxStepsAxis: maxStepsAxis ?? this.maxStepsAxis,
      maxActiveTimeAxis: maxActiveTimeAxis ?? this.maxActiveTimeAxis,
      maxCaloriesAxis: maxCaloriesAxis ?? this.maxCaloriesAxis,
    );
  }
}

final class WeeklyActivitiesLoaded extends DailyActivitiesState {
  final DateTime startOfWeek;
  final DateTime endOfWeek;
  final TimeType timeType;
  final int steps;
  final int activeTime;
  final int calories;
  final int stepsTarget;
  final int activeTimeTarget;
  final int caloriesTarget;
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
    this.steps = 0,
    this.activeTime = 0,
    this.calories = 0,
    required this.stepsTarget,
    required this.activeTimeTarget,
    required this.caloriesTarget,
    required this.dailySteps,
    required this.dailyActiveTime,
    required this.dailyCalories,
    required this.maxStepsAxis,
    required this.maxActiveTimeAxis,
    required this.maxCaloriesAxis,
  });

  WeeklyActivitiesLoaded copyWith({
    DateTime? startOfWeek,
    DateTime? endOfWeek,
    TimeType? timeType,
    int? steps,
    int? activeTime,
    int? calories,
    int? stepsTarget,
    int? activeTimeTarget,
    int? caloriesTarget,
    List<int>? dailySteps,
    List<int>? dailyActiveTime,
    List<int>? dailyCalories,
    int? maxStepsAxis,
    int? maxActiveTimeAxis,
    int? maxCaloriesAxis,
  }) {
    return WeeklyActivitiesLoaded(
      startOfWeek: startOfWeek ?? this.startOfWeek,
      endOfWeek: endOfWeek ?? this.endOfWeek,
      timeType: timeType ?? this.timeType,
      steps: steps ?? this.steps,
      activeTime: activeTime ?? this.activeTime,
      calories: calories ?? this.calories,
      stepsTarget: stepsTarget ?? this.stepsTarget,
      activeTimeTarget: activeTimeTarget ?? this.activeTimeTarget,
      caloriesTarget: caloriesTarget ?? this.caloriesTarget,
      dailySteps: dailySteps ?? this.dailySteps,
      dailyActiveTime: dailyActiveTime ?? this.dailyActiveTime,
      dailyCalories: dailyCalories ?? this.dailyCalories,
      maxStepsAxis: maxStepsAxis ?? this.maxStepsAxis,
      maxActiveTimeAxis: maxActiveTimeAxis ?? this.maxActiveTimeAxis,
      maxCaloriesAxis: maxCaloriesAxis ?? this.maxCaloriesAxis,
    );
  }
}

final class MonthlyActivitiesLoaded extends DailyActivitiesState {
  final DateTime startOfMonth;
  final TimeType timeType;
  final int steps;
  final int activeTime;
  final int calories;
  final List<int> dailySteps;
  final List<int> dailyActiveTime;
  final List<int> dailyCalories;
  final int maxStepsAxis;
  final int maxActiveTimeAxis;
  final int maxCaloriesAxis;

  MonthlyActivitiesLoaded({
    required this.startOfMonth,
    this.timeType = TimeType.week,
    this.steps = 0,
    this.activeTime = 0,
    this.calories = 0,
    required this.dailySteps,
    required this.dailyActiveTime,
    required this.dailyCalories,
    required this.maxStepsAxis,
    required this.maxActiveTimeAxis,
    required this.maxCaloriesAxis,
  });

  MonthlyActivitiesLoaded copyWith({
    DateTime? startOfMonth,
    TimeType? timeType,
    int? steps,
    int? activeTime,
    int? calories,
    List<int>? dailySteps,
    List<int>? dailyActiveTime,
    List<int>? dailyCalories,
    int? maxStepsAxis,
    int? maxActiveTimeAxis,
    int? maxCaloriesAxis,
  }) {
    return MonthlyActivitiesLoaded(
      startOfMonth: startOfMonth ?? this.startOfMonth,
      timeType: timeType ?? this.timeType,
      steps: steps ?? this.steps,
      activeTime: activeTime ?? this.activeTime,
      calories: calories ?? this.calories,
      dailySteps: dailySteps ?? this.dailySteps,
      dailyActiveTime: dailyActiveTime ?? this.dailyActiveTime,
      dailyCalories: dailyCalories ?? this.dailyCalories,
      maxStepsAxis: maxStepsAxis ?? this.maxStepsAxis,
      maxActiveTimeAxis: maxActiveTimeAxis ?? this.maxActiveTimeAxis,
      maxCaloriesAxis: maxCaloriesAxis ?? this.maxCaloriesAxis,
    );
  }
}
