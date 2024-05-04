import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../core/services/shared_pref_service.dart";
import "../../../data/sources/api/people_service.dart";
import "../../../domain/entities/user.dart";

part "profile_state.dart";

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial()) {
    fetchUser();
  }

  Future<void> fetchUser() async {
    final user = await SharedPrefService.getCurrentUser();
    emit(ProfileLoading(user));
    fetchData();
  }

  Future<void> fetchData() async {
    final service = PeopleService();
    final user = (state as ProfileLoading).user;
    final followers = await service.countFollowers(user.uid);
    final followings = await service.countFollowings(user.uid);
    emit(ProfileLoaded(
      user: user, 
      followings: followings, 
      followers: followers,
    ));
  }

  Future<void> pullToRefresh() async {
    final service = PeopleService();
    final user = await SharedPrefService.getCurrentUser();
    final followers = await service.countFollowers(user.uid);
    final followings = await service.countFollowings(user.uid);
    await Future<void>.delayed(const Duration(seconds: 1));
    emit(ProfileLoaded(
      user: user, 
      followings: followings, 
      followers: followers,
    ));
  }
}