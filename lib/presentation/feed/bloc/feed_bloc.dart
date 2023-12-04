import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/sources/api/post_service.dart';
import '../../../domain/entities/post.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  late final StreamSubscription<List<Post>> _postsSubscriber;

  FeedBloc() : super(const FeedLoading()) {
    on<PostsFetched>(_onPostsFetched);
    final service = PostService();
    service.fetchPosts().then((value) => add(PostsFetched(value)));
  }
  
  void _onPostsFetched(PostsFetched event, Emitter<FeedState> emit) {
    emit(FeedLoaded(event.posts));
  }

  @override
  Future<void> close() {
    _postsSubscriber.cancel();
    return super.close();
  }
}
