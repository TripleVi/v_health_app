part of 'block_cubit.dart';

@immutable
sealed class BlockState {
  const BlockState();
}

class BlockLoading extends BlockState {
  const BlockLoading();
}

class BlockLoaded extends BlockState {
  final List<Comment> comments;
  final int totalComments;
  final bool isLoadingMore;
  final int posting;
  final GlobalKey? key;
  final String? snackMsg;

  const BlockLoaded({
    this.comments = const [],
    this.totalComments = 0,
    this.isLoadingMore = false,
    this.posting = 0,
    this.key,
    this.snackMsg,
  });

  BlockLoaded copyWith({
    List<Comment>? comments,
    int? totalComments,
    bool isLoadingMore = false,
    int? posting,
    GlobalKey? key,
    String? snackMsg,
  }) {
    return BlockLoaded(
      comments: comments ?? this.comments,
      totalComments: totalComments ?? this.totalComments,
      isLoadingMore: isLoadingMore,
      posting: posting ?? this.posting,
      key: key,
      snackMsg: snackMsg,
    );
  }
}