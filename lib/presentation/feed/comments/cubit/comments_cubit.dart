import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/user_service.dart';
import '../../../../data/sources/api/post_service.dart';
import '../../../../domain/entities/comment.dart';
import '../../../../domain/entities/user.dart';

part 'comments_state.dart';

class CommentsCubit extends Cubit<CommentsState> {
  StreamController<Map<String, dynamic>>? _streamController;
  final String _postId;
  Comment? _replyTo;
  final _comments = <Comment>[];
  var _totalComments = 0;
  static late ScrollController scrollController;

  CommentsCubit(this._postId) : super(const CommentsLoading()) {
    scrollController =  ScrollController();
    _processComments();
  }

  Future<void> _processComments() async {
    scrollController.addListener(() {
      if(scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
        _loadMoreComments();
      }
    });
    final user = await UserService.getCurrentUser();
    final service = PostService();
    final comments = await service.fetchComments(postId: _postId);
    _totalComments = await service.countIndependentComments(_postId);
    _comments.addAll(comments);
    emit(CommentsLoaded(
      postId: _postId,
      user: user,
      comments: _comments,
      totalComments: _totalComments,
      scrollController: scrollController,
    ));
  }

  Future<Stream<Map<String, dynamic>>> replyToComment(Comment replyTo) async {
    _replyTo = replyTo;
    //? _streamController != null means you're replying to a comment
    await _streamController?.close();
    _streamController = StreamController();
    emit((state as CommentsLoaded).copyWith(replyTo: _replyTo));
    return _streamController!.stream;
  }

  Future<void> writeComment(String content) async {
    content = content.trim();
    if(content.isEmpty) return;
    if(_replyTo == null) {
      return writeIndependentComment(content);
    }
    return writeDependentComment(content);
  }

  Future<void> writeIndependentComment(String content) async {
    try {
      var currentState = state as CommentsLoaded;
      final newComment = Comment.empty()
      ..content = content
      ..author = currentState.user;
      _comments.insert(0, newComment);
      emit(currentState.copyWith(
        comments: _comments,
        totalComments: _totalComments++,
        posting: currentState.posting+1, 
      ));
      final offset = CommentsCubit.scrollController.position.pixels;
      final time = math.max((offset/8).round(), 100);
      scrollController.animateTo(
        0.0, 
        duration: Duration(milliseconds: time), 
        curve: Curves.linear,
      );
      final service = PostService();
      final createdComment = await service.createComment(newComment, _postId);
      final dur = math.max(time+400, 450);
      await Future.delayed(Duration(milliseconds: dur));
      currentState = state as CommentsLoaded;
      if(createdComment == null) {
        _comments.remove(newComment);
        return emit(currentState.copyWith(
          comments: _comments,
          totalComments: _totalComments--,
          posting: currentState.posting-1,
          snackMsg: "Couldn't send your comment",
        ));
      }
      newComment.path = createdComment.path;
      emit(currentState.copyWith(posting: currentState.posting-1));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> writeDependentComment(String content) async {
    final pattern = r'^@' + _replyTo!.author.username;
    final parts = content.split(RegExp(pattern));
    content = parts.length == 1 ? parts[0] : parts[1].trim();
    try {
      final service = PostService();
      final comment = Comment.empty()
      ..content = content
      ..author = (state as CommentsLoaded).user
      ..replyTo = _replyTo;
      final future = service.createComment(comment, _postId);
      _streamController!.sink.add({
        "comment": comment,
        "future": future,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _loadMoreComments() async {
    final curtState = state as CommentsLoaded;
    if(curtState.isLoadingMore 
      || curtState.totalComments == curtState.comments.length) return;
    emit((state as CommentsLoaded).copyWith(
      replyTo: _replyTo,
      isLoadingMore: true,
    ));
    final service = PostService();
    final data = await service.fetchComments(
      postId: _postId,
      lessThanDate: _comments.last.createdDate,
    );
    _comments.addAll(data);
    if(_comments.length > _totalComments) {
      _totalComments = _comments.length;
    }
    emit((state as CommentsLoaded).copyWith(
      replyTo: _replyTo,
      comments: _comments,
      totalComments: _totalComments,
      isLoadingMore: false,
    ));
  }

  Future<void> cancelReplyTo() async {
    _replyTo = null;
    await _streamController!.close();
    _streamController = null;
    emit((state as CommentsLoaded).copyWith());
  }

  @override
  Future<void> close() async {
    scrollController.dispose();
    await _streamController?.close();
    return super.close();
  }

  // void _getPostCommentsHelper(int limit) {
  //   final useCase = GetIt.instance<GetPostCommentsUseCase>();
  //   _commentsSubscriber = useCase(
  //     params: GetPostCommentsParams(
  //       postId: _postId,
  //       limit: limit,
  //     ),
  //   ).listen((comments) async {
  //     final curtState = state as CommentsLoaded;
  //     if(curtState.isLoadingMore) {
  //       return emit(CommentsLoaded(
  //         postId: curtState.postId,
  //         user: curtState.user,
  //         authorUsername: curtState.authorUsername,
  //         commentsLv1: comments,
  //         totalComments: curtState.totalComments,
  //         scrollController: _scrollController,
  //       ));
  //     }

  //     var totalComments = curtState.totalComments;
  //     final useCase = GetIt.instance<CountPostSubCommentsUseCase>();
  //     final total = await useCase(
  //       params: CountPostSubCommentsParams(postId: _postId),
  //     );
  //     if(totalComments == 0) {
  //       totalComments = total;
  //     }

  //     //? some comments added => increase limit
  //     if(total > totalComments && _curtCommentsLimit < total) {
  //       var increase = total - totalComments;
  //       if(increase.remainder(_commentsLimit) != 0) {
  //         increase = increase - increase.remainder(_commentsLimit) + _commentsLimit;
  //       }
  //       _curtCommentsLimit += increase;
  //       totalComments = total;
  //       await _commentsSubscriber.cancel();
  //       _getPostCommentsHelper(_curtCommentsLimit);
  //       return;
  //     }
  //     //? some comments removed => decrease limit
  //     if(total < totalComments && _curtCommentsLimit > total) {
  //       var decrease = totalComments - total;
  //       decrease -= decrease.remainder(_commentsLimit);
  //       _curtCommentsLimit -= decrease;
  //       totalComments = total;
  //       await _commentsSubscriber.cancel();
  //       _getPostCommentsHelper(_curtCommentsLimit);
  //       return;
  //     }

  //     emit(CommentsLoaded(
  //       postId: curtState.postId,
  //       user: curtState.user,
  //       authorUsername: curtState.authorUsername,
  //       commentsLv1: comments,
  //       totalComments: totalComments,
  //       scrollController: _scrollController,
  //     ));
  //   });
  // }
}