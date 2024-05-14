part of "statistics_cubit.dart";

@immutable
sealed class StatisticsState {}

final class StatisticsLoading extends StatisticsState {}

final class StatisticsLoaded extends StatisticsState {
  final DailyReport today;
  final List<DailyReport> recentReports;
  final int goalsAchieved;

  StatisticsLoaded({
    required this.today,
    this.recentReports = const [],
    required this.goalsAchieved,
  });

  StatisticsLoaded copyWith({
    DailyReport? today,
    List<DailyReport>? recentReports,
    int? goalsAchieved,
  }) {
    return StatisticsLoaded(
      today: today ?? this.today,
      recentReports: recentReports ?? this.recentReports,
      goalsAchieved: goalsAchieved ?? this.goalsAchieved,
    );
  } 
}