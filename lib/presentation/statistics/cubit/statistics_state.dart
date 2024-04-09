part of "statistics_cubit.dart";

@immutable
sealed class StatisticsState {}

final class StatisticsLoading extends StatisticsState {}

final class StatisticsLoaded extends StatisticsState {
  final int stepValue;
  final int stepTarget;
  final int minuteValue;
  final int minuteTarget;
  final int calorieValue;
  final int calorieTarget;
  final List<DailyReport> recentReports;

  StatisticsLoaded({
    required this.stepValue,
    required this.stepTarget,
    required this.minuteValue,
    required this.minuteTarget,
    required this.calorieValue,
    required this.calorieTarget,
    this.recentReports = const [],
  });

  StatisticsLoaded copyWith({
    int? stepValue,
    int? stepTarget,
    int? minuteValue,
    int? minuteTarget,
    int? calorieValue,
    int? calorieTarget,
    List<DailyReport>? recentReports,
  }) {
    return StatisticsLoaded(
      stepValue: stepValue ?? this.stepValue,
      stepTarget: stepTarget ?? this.stepTarget,
      minuteValue: minuteValue ?? this.minuteValue,
      minuteTarget: minuteTarget ?? this.minuteTarget,
      calorieValue: calorieValue ?? this.calorieValue,
      calorieTarget: calorieTarget ?? this.calorieTarget,
      recentReports: recentReports ?? this.recentReports,
    );
  } 
}