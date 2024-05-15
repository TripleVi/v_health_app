import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../../core/services/shared_pref_service.dart";
import "../../../../data/sources/api/people_service.dart";
import "../../../../data/sources/api/post_service.dart";
import "../../../../domain/entities/reaction.dart";
import "../../../../domain/entities/user.dart";

part "likes_state.dart";

class LikesCubit extends Cubit<LikesState> {
  final String postId;

  LikesCubit(this.postId) : super(const LikesLoading()) {
    _fetchData();
  }

  Future<void> _fetchData() async {
    final service = PostService();
    final reactions = await service.fetchUserReactions(postId);
    final user = await SharedPrefService.getCurrentUser();
    emit(LikesLoaded(
      user: user, 
      reactions: reactions,
    ));
  }

  Future<bool> followPeople(String uid) async {
    final service = PeopleService();
    final isFollowing = await service.followPeople(uid);
    if(!isFollowing) {
      emit((state as LikesLoaded).copyWith(
        snackMsg: "Couldn't follow this account"
      ));
    }
    return isFollowing;
  }

  Future<bool> unfollowFriend(String uid) async {
    final service = PeopleService();
    final isUnfollowing = await service.unfollowPeople(uid);
    if(!isUnfollowing) {
      emit((state as LikesLoaded).copyWith(
        snackMsg: "Couldn't unfollow this account"
      ));
    }
    return isUnfollowing;
  }
}
