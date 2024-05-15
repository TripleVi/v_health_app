part of 'comments_cubit.dart';

@immutable
sealed class CommentsState {
  const CommentsState();
}

class CommentsLoading extends CommentsState {
  const CommentsLoading();
}

class CommentsLoaded extends CommentsState {
  final String postId;
  final User user;
  final Comment? replyTo;
  final List<Comment> comments;
  final int totalComments;
  final bool isLoadingMore;
  final int posting;
  final ScrollController scrollController;
  final String? snackMsg;

  const CommentsLoaded({
    required this.postId,
    required this.user,
    this.replyTo,
    required this.comments,
    required this.totalComments,
    this.isLoadingMore = false,
    this.posting = 0,
    required this.scrollController,
    this.snackMsg,
  });

  CommentsLoaded copyWith({
    Comment? replyTo,
    List<Comment>? comments,
    int? totalComments,
    bool? isLoadingMore,
    int? posting,
    String? snackMsg,
  }) {
    return CommentsLoaded(
      postId: postId,
      user: user,
      replyTo: replyTo,
      comments: comments ?? this.comments,
      totalComments: totalComments ?? this.totalComments,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      posting: posting ?? this.posting,
      scrollController: scrollController,
      snackMsg: snackMsg,
    );
  }
}