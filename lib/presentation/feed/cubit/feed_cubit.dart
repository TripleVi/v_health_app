import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../data/sources/api/post_service.dart";
import "../../../domain/entities/post.dart";

part "feed_state.dart";

class FeedCubit extends Cubit<FeedState> {
  FeedCubit() : super(FeedLoading()) {
    fetchData();
  }

  Future<void> fetchData() async {
    final service = PostService();
    final posts = await service.fetchPosts();
    emit(FeedLoaded(posts));
  }

  Future<void> pullToRefresh() async {
    emit(FeedLoaded((state as FeedLoaded).posts));
  }
}
