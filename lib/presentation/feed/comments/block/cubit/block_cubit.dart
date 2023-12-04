import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../../data/repositories/user_repo.dart';
import '../../../../../domain/entities/comment.dart';
import '../../../../../domain/entities/user.dart';
import '../../../../../domain/usecases/feed/post/count_post_sub_comments.dart';
import '../../../../../domain/usecases/feed/post/get_post_comments.dart';

part 'block_state.dart';

class BlockCubit extends Cubit<BlockState> {
  final _commentsLimit = 5;
  int _curtCommentsLimit = 0;
  int _totalComments = 0;
  final String _postId;
  final Comment _parent;
  bool newComment = false;
  StreamSubscription<List<Comment>>? _commentsSubscriber;

  BlockCubit(this._postId, this._parent, this.newComment) : super(const BlockLoading()) {
    print("Constructor BlockCubit");
    newComment ? _getPostCommentsHelper(_commentsLimit) : _processBlock();
  }

  Future<void> _processBlock() async {
    // final user = await GetIt.instance<UserRepo>().getUser();
    // final useCase = GetIt.instance<CountPostSubCommentsUseCase>();
    // _totalComments = await useCase(
    //   params: CountPostSubCommentsParams(
    //     postId: _postId,
    //     parentId: _parent.id,
    //   ),
    // );
    // emit(BlockLoaded(
    //   user: user,
    //   totalComments: _totalComments,
    // ));
  }

  void _getPostCommentsHelper(int limit) {
    // final useCase = GetIt.instance<GetPostCommentsUseCase>();
    // _commentsSubscriber = useCase(
    //   params: GetPostCommentsParams(
    //     postId: _postId,
    //     parentId: _parent.id,
    //     limit: limit,
    //   ),
    // ).listen((comments) async {
    //   final useCase = GetIt.instance<CountPostSubCommentsUseCase>();
    //   _totalComments = await useCase(
    //     params: CountPostSubCommentsParams(
    //       postId: _postId, 
    //       parentId: _parent.id,
    //     ),
    //   );
    //   emit(BlockLoaded(
    //     user: (state as BlockLoaded).user,
    //     comments: comments, 
    //     totalComments: _totalComments,
    //   ));
    //   if(_totalComments == 0) {
    //     await _commentsSubscriber!.cancel();
    //   }
    // });
  }

  Future<void> viewMoreComments() async {
    final curtState = state as BlockLoaded;
    if(curtState.isLoadingMore) return;

    emit(BlockLoaded(
      user: curtState.user,
      comments: curtState.comments,
      totalComments: _totalComments,
      isLoadingMore: true,
    ));
    _curtCommentsLimit += _commentsLimit;
    await _commentsSubscriber?.cancel();
    _getPostCommentsHelper(_curtCommentsLimit);
  }

  Future<void> hideAllComments() async {
    await _commentsSubscriber!.cancel();
    emit(BlockLoaded(
      user: (state as BlockLoaded).user,
      totalComments: _totalComments,
    ));
  }

  Future<void> onCommentAdded() async {
    if(_totalComments == 0) {
      _totalComments = 1;
      return viewMoreComments();
    }
  }

  @override
  Future<void> close() async {
    await _commentsSubscriber?.cancel();
    return super.close();
  }
}