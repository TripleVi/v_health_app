import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_health/presentation/feed/comments/cubit/comments_cubit.dart';

import '../../../../../data/sources/api/post_service.dart';
import '../../../../../domain/entities/comment.dart';

part 'block_state.dart';

class BlockCubit extends Cubit<BlockState> {
  final String _postId;
  final Comment _parent;
  final _comments = <Comment>[];
  final _newComments = <Comment>[];
  var _isProcessing = false;
  GlobalKey? key;

  BlockCubit(this._postId, this._parent) : super(const BlockLoading()) {
    _processBlock();
  }

  Future<void> _processBlock() async {
    final service = PostService();
    final total = await service.countComments(_postId, "${_parent.path}/");
    emit(BlockLoaded(totalComments: total));
  }

  Future<void> onCommentPosting(Map<String, dynamic> params) async {
    final newComment = params["comment"] as Comment;
    final commentFuture = params["future"] as Future;
    final currentState = state as BlockLoaded;
    _newComments.add(newComment);
    final comments = List<Comment>.from(_comments);
    comments.addAll(_newComments);
    key = GlobalKey();
    emit(currentState.copyWith(
      comments: comments, 
      totalComments: currentState.totalComments+1, 
      posting: currentState.posting+1,
      key: key,
    ));
    return WidgetsBinding.instance.addPostFrameCallback((_) async {
      final box = key!.currentContext!.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero);
      final dy = position.dy;
      final viewport = CommentsCubit.scrollController.position.viewportDimension;
      final offset = CommentsCubit.scrollController.position.pixels;
      final newOffset = math.max(offset+dy-viewport+8.0, 0.0);
      final distance = (offset - newOffset).abs();
      final time = math.max((distance / 8).round(), 150);
      CommentsCubit.scrollController.animateTo(
        newOffset, 
        duration: Duration(milliseconds: time), 
        curve: Curves.linear,
      );
      final createdComment = (await commentFuture) as Comment?;
      final dur = math.max(time+400, 450);
      await Future.delayed(Duration(milliseconds: dur));
      key = null;
      onCommentPosted(createdComment, newComment);
    });
  }

  void onCommentPosted(Comment? remote, Comment local) {
    final currentState = state as BlockLoaded;
    if(remote == null) {
      _newComments.remove(local);
      final comments = List<Comment>.from(_comments);
      comments.addAll(_newComments);
      return emit(currentState.copyWith(
        comments: comments,
        totalComments: currentState.totalComments-1,
        posting: currentState.posting-1,
        snackMsg: "Couldn't reply to another"
      ));
    }
    local.path = remote.path;
    emit(currentState.copyWith(posting: currentState.posting-1));
  }

  Future<void> viewMoreReplies() async {
    final currentState = state as BlockLoaded;
    if(currentState.isLoadingMore) return;
    emit(currentState.copyWith(isLoadingMore: true));
    final service = PostService();
    if(_comments.isEmpty) {
      final data = await service.fetchComments(
        postId: _postId,
        path: "${_parent.id}/",
      );
      _comments.addAll(data);
    }else {
      final data = await service.fetchComments(
        postId: _postId,
        path: "${_parent.id}/",
        lessThanDate: _comments.last.createdDate,
      );
      _comments.addAll(data);
    }
    final comments = List<Comment>.from(_comments);
    comments.addAll(_newComments);
    emit((state as BlockLoaded).copyWith(comments: comments));
  }

  Future<void> hideAllReplies() async {
    if(_isProcessing) return;
    _isProcessing = true;
    _comments.clear();
    _newComments.clear();
    await _processBlock();
    _isProcessing = false;
  }

  // void _getPostCommentsHelper(int limit) {
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
  // }
}