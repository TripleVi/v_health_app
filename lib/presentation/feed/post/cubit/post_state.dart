part of 'post_cubit.dart';

@immutable
sealed class PostState {
  const PostState();
}

final class PostLoading extends PostState {
  const PostLoading();
}

final class PostLoaded extends PostState {
  final int index;
  final Post post;
  final bool isLiked;
  final int likes;
  final int comments;
  final String txtDate;
  final String recordTime;
  final bool readMore;

  const PostLoaded({
    required this.index,
    required this.post,
    required this.isLiked,
    required this.likes,
    required this.comments,
    required this.txtDate,
    required this.recordTime,
    this.readMore = false,
  });

  PostLoaded copyWith({
    bool? isLiked,
    int? likes,
    int? comments,
    bool? readMore,
  }) {
    return PostLoaded(
      index: index,
      post: post,
      isLiked: isLiked ?? this.isLiked,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      txtDate: txtDate, 
      recordTime: recordTime, 
      readMore: readMore ?? this.readMore,
    );
  }
}