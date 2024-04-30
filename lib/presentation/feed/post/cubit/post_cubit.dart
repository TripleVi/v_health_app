import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:timeago/timeago.dart" as ta;

import "../../../../data/sources/api/post_service.dart";
import "../../../../domain/entities/post.dart";

part "post_state.dart";

class PostCubit extends Cubit<PostState> {
  final int index;
  final Post post;
  var isProcessing = false;

  PostCubit(this.index, this.post) : super(const PostLoading()) {
    _processPost();
  }

  Future<void> _processPost() async {
    final service = PostService();
    final map = await service.countLikes(post.id);
    final comments = await service.countComments(post.id);
    final txtDate = ta.format(post.createdDate, locale: "en");
    final record = post.record;
    final rDuration = record.endDate.difference(record.startDate);
    String rTime = "";
    final hours = rDuration.inHours;
    final minutes = rDuration.inMinutes - rDuration.inHours * 60;
    if(rDuration.inHours > 0) {
      rTime = "$hours h";
    }
    if(rDuration.inMinutes > 0) {
      rTime = "${rTime.isEmpty ? "$rTime " : ""}$minutes m";
    }
    if(rDuration.inSeconds <= 59) {
      rTime = "${rDuration.inSeconds} s";
    }
    emit(PostLoaded(
      index: index,
      post: post,
      isLiked: map["isLiked"],
      likes: map["likes"],
      comments: comments,
      txtDate: txtDate,
      recordTime: rTime,
    ));
  }

  Future<void> likePost() async {
    if(isProcessing) return;
    isProcessing = true;
    final curtState = state as PostLoaded;
    try {
      final service = PostService();
      if(curtState.isLiked) {
        await service.unlikePost(post.id);
        isProcessing = false;
        return emit(curtState.copyWith(isLiked: false, likes: curtState.likes-1));
      }
      await service.likePost(post.id);
      isProcessing = false;
      emit(curtState.copyWith(isLiked: true, likes: curtState.likes+1));
    } catch (e) {
      rethrow;
    }
  }

  void toggleReadMore() {
    final current = state as PostLoaded;
    emit(current.copyWith(readMore: !current.readMore));
  }

  Future<void> updatePostInfo() async {
    final curtState = state as PostLoaded;
    final service = PostService();
    final map = await service.countLikes(post.id);
    final likes = map["likes"];
    final comments = await service.countComments(post.id);
    if(likes != curtState.likes || comments != curtState.comments) {
      emit(curtState.copyWith(
        likes: likes,
        comments: comments,
      ));
    }
  }
}