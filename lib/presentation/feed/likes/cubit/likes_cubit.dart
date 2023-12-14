import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/sources/api/post_service.dart';
import '../../../../domain/entities/reaction.dart';

part 'likes_state.dart';

class LikesCubit extends Cubit<LikesState> {
  final String postId;

  LikesCubit(this.postId) : super(const LikesLoading()) {
    processFetchingData();
  }

  Future<void> processFetchingData() async {
    final service = PostService();
    final reactions = await service.fetchUserReactions(postId);
    emit(LikesLoaded(reactions));
  }
}
