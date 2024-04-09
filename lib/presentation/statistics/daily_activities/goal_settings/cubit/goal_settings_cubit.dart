import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'goal_settings_state.dart';

class GoalSettingsCubit extends Cubit<GoalSettingsState> {
  GoalSettingsCubit() : super(GoalSettingsInitial());

  void setDailyGoalDetails({int? steps, int? minutes, int? calories}) {
    
  }
}
