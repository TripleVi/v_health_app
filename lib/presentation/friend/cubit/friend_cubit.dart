import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_health/core/services/shared_pref_service.dart';

import '../../../data/sources/api/friend_service.dart';
import '../../../domain/entities/friend.dart';
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
      friends: const [],
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
      emit(curtState.copyWith(friends: const []));
      _isProcessing = false;
      return;
    }
    emit(curtState.copyWith(isProcessing: true));
    final service = FriendService();
    final friends = await service.fetchUsersByUsername(keyword);
    await Future.delayed(const Duration(milliseconds: 500));
    emit((state as FriendLoaded).copyWith(friends: friends));
    _isProcessing = false;
  }

  Future<bool> followFriend(Friend friend) async {
    final service = FriendService();
    final isFollowing = await service.followFriend(friend.uid);
    if(!isFollowing) {
      emit((state as FriendLoaded).copyWith(
        snackMsg: "Couldn't follow this account"
      ));
    }
    return isFollowing;
  }

  Future<bool> unfollowFriend(Friend friend) async {
    final service = FriendService();
    final isUnfollowing = await service.unfollowFriend(friend.uid);
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
