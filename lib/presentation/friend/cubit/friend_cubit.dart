import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_health/core/services/shared_pref_service.dart';

import '../../../data/sources/api/people_service.dart';
import '../../../domain/entities/people.dart';
import '../../../domain/entities/user.dart';

part 'friend_state.dart';

class FriendCubit extends Cubit<FriendState> {
  final _searchController = TextEditingController();
  var _isProcessing = false;

  FriendCubit() : super(const FriendLoading()) {
    _fetchData();
  }

  Future<void> _fetchData() async {
    final user = await SharedPrefService.getCurrentUser();
    emit(FriendLoaded(
      user: user,
      searchController: _searchController,
    ));
  }

  void searchingStatusOff() {
    _searchController.text = "";
    emit((state as FriendLoaded).copyWith(
      people: const [],
      isSearching: false,
    ));
  }

  void searchingStatusOn() {
    emit((state as FriendLoaded).copyWith(isSearching: true));
  }

  Future<void> searchUserByUsername(String keyword) async {
    if(_isProcessing) return;
    _isProcessing = true;
    final curtState = state as FriendLoaded;
    keyword = keyword.trim();
    if(keyword.isEmpty) {
      emit(curtState.copyWith(people: const []));
      _isProcessing = false;
      return;
    }
    emit(curtState.copyWith(isProcessing: true));
    final service = PeopleService();
    final people = await service.fetchUsersByUsername(keyword);
    await Future.delayed(const Duration(milliseconds: 500));
    emit((state as FriendLoaded).copyWith(people: people));
    _isProcessing = false;
  }

  Future<bool> followFriend(String uid) async {
    final service = PeopleService();
    final isFollowing = await service.followPeople(uid);
    if(!isFollowing) {
      emit((state as FriendLoaded).copyWith(
        snackMsg: "Couldn't follow this account"
      ));
    }
    return isFollowing;
  }

  Future<bool> unfollowFriend(String uid) async {
    final service = PeopleService();
    final isUnfollowing = await service.unfollowPeople(uid);
    if(!isUnfollowing) {
      emit((state as FriendLoaded).copyWith(
        snackMsg: "Couldn't unfollow this account"
      ));
    }
    return isUnfollowing;
  }

  @override
  Future<void> close() {
    _searchController.dispose();
    return super.close();
  }
}
