import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../core/services/shared_pref_service.dart";
import "../../../data/sources/api/people_service.dart";
import "../../../data/sources/api/post_service.dart";
import "../../../data/sources/api/user_api.dart";
import "../../../domain/entities/user.dart";

part "profile_state.dart";

class ProfileCubit extends Cubit<ProfileState> {
  User? user;
  var other = false;

  ProfileCubit(this.user) : super(ProfileInitial()) {
    fetchUser();
  }

  Future<void> fetchUser() async {
    if(user == null) {
      user = await SharedPrefService.getCurrentUser();
    }else {
      final service = UserService();
      user = await service.getUserById(user!.uid);
      other = true;
    }
    emit(ProfileLoading(user!));
    fetchData();
  }

  Future<void> fetchData() async {
    final userService = PeopleService();
    final postService = PostService();
    final followers = await userService.countFollowers(user!.uid);
    final followings = await userService.countFollowings(user!.uid);
    final posts = await postService.countPosts(user!);
    emit(ProfileLoaded(
      user: user!, 
      followings: followings, 
      followers: followers,
      posts: posts,
      other: other,
    ));
  }

  Future<void> pullToRefresh() async {
    final service = PeopleService();
    final postService = PostService();
    final user = await SharedPrefService.getCurrentUser();
    final followers = await service.countFollowers(user.uid);
    final followings = await service.countFollowings(user.uid);
    final posts = await postService.countPosts(user);
    await Future<void>.delayed(const Duration(seconds: 1));
    emit(ProfileLoaded(
      user: user, 
      followings: followings, 
      followers: followers,
      posts: posts,
      other: other,
    ));
  }
}