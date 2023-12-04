part of 'comments_cubit.dart';

@immutable
abstract class CommentsState {
  const CommentsState();
}

class CommentsLoading extends CommentsState {
  const CommentsLoading();
}

class CommentsLoaded extends CommentsState {
  final String postId;
  final User user;
  final String? authorUsername;
  final List<Comment> commentsLv1;
  final int totalComments;
  final bool isLoadingMore;
  final ScrollController scrollController;

  const CommentsLoaded({
    required this.postId,
    required this.user,
    this.authorUsername,
    this.commentsLv1 = const [],
    this.totalComments = 0,
    this.isLoadingMore = false,
    required this.scrollController,
  });
}

class CommentsError extends CommentsState {
  final String message;

  const CommentsError(this.message);
}