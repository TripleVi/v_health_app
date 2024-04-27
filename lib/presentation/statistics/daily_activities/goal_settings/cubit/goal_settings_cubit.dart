import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/repositories/daily_goal_repo.dart';
import '../../../../../domain/entities/daily_goal.dart';

part 'goal_settings_state.dart';

class GoalSettingsCubit extends Cubit<GoalSettingsState> {
  GoalSettingsCubit() : super(GoalSettingsLoading()) {
    fetchData();
  }

  Future<void> fetchData() async {
    final repo = DailyGoalRepo();
    final goal = await repo.fetchLatestGoal();
    emit(GoalSettingsLoaded(goal ?? DailyGoal.empty()));
  }

  Future<void> setDailyGoalDetails({int? steps, int? minutes, int? calories}) async {
    final curtState = state as GoalSettingsLoaded;
    final repo = DailyGoalRepo();
    final goal = DailyGoal.empty()
    ..steps = steps ?? curtState.dailyGoal.steps
    ..activeTime = minutes ?? curtState.dailyGoal.activeTime
    ..calories = calories ?? curtState.dailyGoal.calories;
    await repo.createGoal(goal);
    emit(GoalSettingsLoaded(goal));
  }
}
