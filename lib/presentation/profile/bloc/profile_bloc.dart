import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/shared_pref_service.dart';
import '../../../data/sources/api/friend_service.dart';
import '../../../data/sources/api/post_service.dart';
import '../../../domain/entities/user.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileLoading()) {
    on<UserFetched>((event, emit) async {
      final user = await SharedPrefService.getCurrentUser();
      final service = FriendService();
      final followers = await service.countFollowers(user.uid);
      final followings = await service.countFollowings(user.uid);
      emit(ProfileLoaded(
        user: user,
        followers: followers,
        followings: followings,
      ));
    });

    add(const UserFetched());
  }
}
