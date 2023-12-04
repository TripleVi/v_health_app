part of 'post_cubit.dart';

abstract class PostState {
  const PostState();
}

class PostLoading extends PostState {
  const PostLoading();
}

class PostLoaded extends PostState {
  final Post post;
  final bool isLiked;
  final int likes;
  final int comments;
  final String txtDate;
  final String recordTime;
  final String address;

  const PostLoaded({
    required this.post,
    this.isLiked = false,
    this.likes = 0,
    this.comments = 0,
    required this.txtDate,
    required this.recordTime,
    required this.address,
  });
}

class PostError extends PostState {
  final String message;
  const PostError(this.message);
}