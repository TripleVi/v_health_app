part of 'post_cubit.dart';

@immutable
sealed class PostState {
  const PostState();
}

final class PostLoading extends PostState {
  const PostLoading();
}

final class PostLoaded extends PostState {
  final Post post;
  final bool isLiked;
  final int likes;
  final int comments;
  final String txtDate;
  final String recordTime;
  final String address;

  const PostLoaded({
    required this.post,
    required this.isLiked,
    required this.likes,
    required this.comments,
    required this.txtDate,
    required this.recordTime,
    required this.address,
  });

  PostLoaded copyWith({
    bool? isLiked,
    int? likes,
    int? comments,
  }) {
    return PostLoaded(
      post: post,
      isLiked: isLiked ?? this.isLiked,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      txtDate: txtDate, 
      recordTime: recordTime, 
      address: address,
    );
  }
}