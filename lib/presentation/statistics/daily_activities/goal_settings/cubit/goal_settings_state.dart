part of 'goal_settings_cubit.dart';

@immutable
sealed class GoalSettingsState {}

final class GoalSettingsLoading extends GoalSettingsState {}

final class GoalSettingsLoaded extends GoalSettingsState {
  final DailyGoal dailyGoal;

  GoalSettingsLoaded(this.dailyGoal);
}