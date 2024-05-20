import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:timeago/timeago.dart" as ta;

import "../../../data/sources/api/post_service.dart";

part "post_state.dart";

class PostCubit extends Cubit<PostState> {
  final PostData data;
  var isProcessing = false;

  PostCubit(this.data) : super(PostLoaded(data: data));

  Future<void> likePost() async {
    if(isProcessing) return;
    isProcessing = true;
    final curtState = state as PostLoaded;
    try {
      final service = PostService();
      if(curtState.data.isLiked) {
        await service.unlikePost(data.post.id);
        isProcessing = false;
        data..isLiked = false
        ..likes = curtState.data.likes-1;
        return emit(curtState.copyWith());
      }
      await service.likePost(data.post.id);
      isProcessing = false;
      data..isLiked = true
      ..likes = curtState.data.likes+1;
      emit(curtState.copyWith());
    } catch (e) {
      rethrow;
    }
  }

  void toggleReadMore() {
    final current = state as PostLoaded;
    emit(current.copyWith(readMore: !current.readMore));
  }

  Future<void> updatePostInfo() async {
    // final curtState = state as PostLoaded;
    // final service = PostService();
    // final map = await service.countLikes(post.id);
    // final likes = map["likes"];
    // final comments = await service.countComments(post.id);
    // if(likes != curtState.likes || comments != curtState.comments) {
    //   emit(curtState.copyWith(
    //     likes: likes,
    //     comments: comments,
    //   ));
    // }
  }

  @override
  Future<void> close() async {
    super.close();
    print(data.post.id);
    print("closed");
  }
}