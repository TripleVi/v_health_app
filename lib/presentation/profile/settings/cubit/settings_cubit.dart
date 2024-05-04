import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../../core/services/auth_service.dart";

part "settings_state.dart";

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial());

  Future<void> logout() {
    return AuthService.instance.signOut();
  }
}
