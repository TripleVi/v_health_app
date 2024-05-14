import "dart:math" as math;

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../data/sources/api/feed_service.dart";
import "../../../data/sources/api/post_service.dart";
import "../../../domain/entities/post.dart";

part "feed_state.dart";

class FeedCubit extends Cubit<FeedState> {
  var endIndex = 0;

  FeedCubit() : super(FeedLoading()) {
    fetchData();
  }

  Future<void> fetchData() async {
    // final postService = PostService();
    // final posts = await postService.fetchPosts();
    // emit(FeedLoaded(posts));

    final service = FeedService();
    final postIds = await service.fetchNewsFeed([]);
    final posts = await service.fetchPostsByIds(postIds);
    emit(FeedLoaded(posts));
  }

  Future<void> test() async {
    
    emit(FeedLoading());
    final postService = PostService();
    final posts = await postService.fetchPosts("ZgGHGfcI73QoDEKpCBjA5ioGrlp2");
    emit(FeedLoaded(posts));
  }

  Future<void> pullToRefresh() async {
    // fetchData();
    // return;
    final service = FeedService();
    final current = state as FeedLoaded;
    final ids = <String>[];
    if(current.posts.isNotEmpty) {
      for (var i = 0; i <= endIndex; i++) {
        ids.add(current.posts[i].id);
      }
      endIndex = 0;
    }
    final postIds = await service.fetchNewsFeed(ids);
    final posts = await service.fetchPostsByIds(postIds);
    await Future.delayed(const Duration(milliseconds: 500)).then((_) {
      Future.delayed(const Duration(milliseconds: 100)).then((_) async {
        emit(FeedRefreshed());
        await Future.delayed(const Duration(milliseconds: 100));
        emit(FeedLoaded(posts));
      });
    });
  }

  void viewPost(int index) {
    endIndex = math.max(endIndex, index);
  }
}
