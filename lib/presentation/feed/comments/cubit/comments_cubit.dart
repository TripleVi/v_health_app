import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/services/user_service.dart';
import '../../../../data/repositories/user_repo.dart';
import '../../../../domain/entities/comment.dart';
import '../../../../domain/entities/user.dart';
import '../../../../domain/usecases/feed/post/add_post_comment.dart';
import '../../../../domain/usecases/feed/post/count_post_sub_comments.dart';
import '../../../../domain/usecases/feed/post/get_post_comments.dart';

part 'comments_state.dart';

class CommentsCubit extends Cubit<CommentsState> {
  final _commentsLimit = 10;
  int _curtCommentsLimit = 0;
  late StreamSubscription<List<Comment>> _commentsSubscriber;
  Completer<bool>? _commentCompleter;
  final String _postId;
  Comment? _parent;
  final _scrollController = ScrollController();

  CommentsCubit(this._postId) : super(const CommentsLoading()) {
    _processComments();
  }

  Future<void> _processComments() async {
    final user = await UserService.getCurrentUser();
    _scrollController.addListener(() {
      if(_scrollController.position.pixels 
        >= _scrollController.position.maxScrollExtent) {
        loadMoreComments();
      }
    });
    emit(CommentsLoaded(
      postId: _postId,
      user: user,
      scrollController: _scrollController,
    ));
    _getPostCommentsHelper(_commentsLimit);
  }

  void _getPostCommentsHelper(int limit) {
    // final useCase = GetIt.instance<GetPostCommentsUseCase>();
    // _commentsSubscriber = useCase(
    //   params: GetPostCommentsParams(
    //     postId: _postId,
    //     limit: limit,
    //   ),
    // ).listen((comments) async {
    //   final curtState = state as CommentsLoaded;
    //   if(curtState.isLoadingMore) {
    //     return emit(CommentsLoaded(
    //       postId: curtState.postId,
    //       user: curtState.user,
    //       authorUsername: curtState.authorUsername,
    //       commentsLv1: comments,
    //       totalComments: curtState.totalComments,
    //       scrollController: _scrollController,
    //     ));
    //   }

    //   var totalComments = curtState.totalComments;
    //   final useCase = GetIt.instance<CountPostSubCommentsUseCase>();
    //   final total = await useCase(
    //     params: CountPostSubCommentsParams(postId: _postId),
    //   );
    //   if(totalComments == 0) {
    //     totalComments = total;
    //   }

    //   //? some comments added => increase limit
    //   if(total > totalComments && _curtCommentsLimit < total) {
    //     var increase = total - totalComments;
    //     if(increase.remainder(_commentsLimit) != 0) {
    //       increase = increase - increase.remainder(_commentsLimit) + _commentsLimit;
    //     }
    //     _curtCommentsLimit += increase;
    //     totalComments = total;
    //     await _commentsSubscriber.cancel();
    //     _getPostCommentsHelper(_curtCommentsLimit);
    //     return;
    //   }
    //   //? some comments removed => decrease limit
    //   if(total < totalComments && _curtCommentsLimit > total) {
    //     var decrease = totalComments - total;
    //     decrease -= decrease.remainder(_commentsLimit);
    //     _curtCommentsLimit -= decrease;
    //     totalComments = total;
    //     await _commentsSubscriber.cancel();
    //     _getPostCommentsHelper(_curtCommentsLimit);
    //     return;
    //   }

    //   emit(CommentsLoaded(
    //     postId: curtState.postId,
    //     user: curtState.user,
    //     authorUsername: curtState.authorUsername,
    //     commentsLv1: comments,
    //     totalComments: totalComments,
    //     scrollController: _scrollController,
    //   ));
    // });
  }

  Future<bool> replyComment(Comment parent) {
    final curtState = state as CommentsLoaded;
    _parent = parent;
    emit(CommentsLoaded(
      postId: _postId,
      user: curtState.user,
      authorUsername: parent.author.username,
      commentsLv1: curtState.commentsLv1,
      totalComments: curtState.totalComments,
      scrollController: _scrollController,
    ));
    _commentCompleter = Completer();
    return _commentCompleter!.future;
  }

  Future<void> writeComment(String content) async {
    // if(content.isEmpty) {
    //   return _commentCompleter!.complete(false);
    // }
    // if(_parent != null) {
    //   final pattern = r'^@' + _parent!.username;
    //   content = content.split(RegExp(pattern))[1];
    //   if(content.isEmpty) {
    //     return _commentCompleter!.complete(false);
    //   }
    // }

    // const maxLevel = 2;
    // final useCase = GetIt.instance<AddPostCommentUseCase>();
    // try {
    //   final user = await _userFuture;
    //   final curtState = state as CommentsLoaded;
    //   var parentId = _parent?.id;
    //   //? ancestor (lv1)
    //   if(_parent != null && _parent!.level != 1) {
    //     parentId = _parent!.parentId;
    //   }
    //   final comment = Comment(
    //     userId: user.id,
    //     username: user.username,
    //     avatarUrl: user.avatarUrl,
    //     content: content,
    //     parentId: parentId,
    //     authorId: _parent?.userId,
    //     authorUsername: _parent?.username,
    //   )
    //   ..level = math.min<int>((_parent?.level ?? 0) + 1, maxLevel);
    //   await useCase(
    //     params: AddPostCommentParams(_postId, comment),
    //   );
    //   _parent == null;
    //   emit(CommentsLoaded(
    //     postId: _postId,
    //     user: curtState.user,
    //     commentsLv1: curtState.commentsLv1,
    //     totalComments: curtState.totalComments,
    //     scrollController: _scrollController,
    //   ));
    //   return _commentCompleter!.complete(true);
    // } catch (e) {
    //   rethrow;
    //   // emit(const CommentError("Something went wrong."));
    // }
  }

  Future<void> loadMoreComments() async {
    final curtState = state as CommentsLoaded;
    if(curtState.isLoadingMore 
      || curtState.totalComments <= curtState.commentsLv1.length) return;

    emit(CommentsLoaded(
      postId: curtState.postId,
      user: curtState.user,
      authorUsername: curtState.authorUsername,
      commentsLv1: curtState.commentsLv1,
      totalComments: curtState.totalComments,
      isLoadingMore: true,
      scrollController: _scrollController,
    ));

    _curtCommentsLimit += _commentsLimit;
    await _commentsSubscriber.cancel();
    _getPostCommentsHelper(_curtCommentsLimit);
  }

  void cancelReplyFor() {
    final curtState = state as CommentsLoaded;
    _parent = null;
    emit(CommentsLoaded(
      postId: curtState.postId,
      user: curtState.user,
      commentsLv1: curtState.commentsLv1,
      totalComments: curtState.totalComments,
      scrollController: _scrollController,
    ));
  }

  @override
  Future<void> close() async {
    await _commentsSubscriber.cancel();
    _scrollController.dispose();
    return super.close();
  }

}