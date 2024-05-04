import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../../core/enum/user_enum.dart";
import "../../../../core/services/shared_pref_service.dart";
import "../../../../data/sources/api/user_api.dart";
import "../../../../domain/entities/user.dart";

part "profile_details_state.dart";

class ProfileDetailsCubit extends Cubit<ProfileDetailsState> {
  ProfileDetailsCubit() : super(ProfileDetailsLoading()) {
    fetchData();
  }

  Future<void> fetchData() async {
    final user = await SharedPrefService.getCurrentUser();
    emit(ProfileDetailsLoaded(user: user));
  }

  Future<void> onProfileEdited() {
    return fetchData();
  }

  Future<void> updateWeight(String txtValue) async {
    final weight = double.parse(txtValue);
    final user = await SharedPrefService.getCurrentUser();
    user.weight = weight;
    return submit(user);
  }

  Future<void> updateHeight(int height) async {
    final user = await SharedPrefService.getCurrentUser();
    user.height = height;
    return submit(user);
  }

  Future<void> updateGender(int type) async {
    final user = await SharedPrefService.getCurrentUser();
    user.gender = UserGender.values[type];
    return submit(user);
  }

  Future<void> submit(User user) async {
    final service = UserService();
    final result = await service.editProfile(user);
    if(result) {
      await SharedPrefService.updateCurrentUser(user);
      return emit(ProfileDetailsLoaded(
        user: user,
        snackMsg: "Edited profile successfully!",
      ));
    }
    emit((state as ProfileDetailsLoaded)
        .copyWith(snackMsg: "Oops, something went wrong!"));
  }
}
