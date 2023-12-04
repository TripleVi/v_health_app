import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../domain/entities/reaction.dart';
import '../../../../domain/usecases/feed/post/get_post_reactions.dart';

part 'likes_state.dart';

class LikesCubit extends Cubit<LikesState> {
  final String _postId;
  late final StreamSubscription<List<Reaction>> _reactionsSubscriber;

  LikesCubit(this._postId) : super(const LikesLoading()) {
    processLikes();
  }

  void processLikes() {
    // final getPostReactionsUseCase = GetIt.instance<GetPostReactionsUseCase>();
    // _reactionsSubscriber = getPostReactionsUseCase(params: _postId)
    //     .listen((reactions) => emit(LikesLoaded(reactions)));
  }

  @override
  Future<void> close() async {
    await _reactionsSubscriber.cancel();
    return super.close();
  }
}
