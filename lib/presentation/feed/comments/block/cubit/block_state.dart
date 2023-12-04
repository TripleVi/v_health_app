part of 'block_cubit.dart';

@immutable
abstract class BlockState {
  const BlockState();
}

class BlockLoading extends BlockState {
  const BlockLoading();
}

class BlockLoaded extends BlockState {
  final User user;
  final List<Comment> comments;
  final int totalComments;
  final bool isLoadingMore;

  const BlockLoaded({
    required this.user,
    this.comments = const [],
    this.totalComments = 0,
    this.isLoadingMore = false,
  });
}

class BlockError extends BlockState {
  final String message;
  const BlockError(this.message);
}