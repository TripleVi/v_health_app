part of 'feed_bloc.dart';

@immutable
abstract class FeedState {
  const FeedState();
}

class FeedLoading extends FeedState {
  const FeedLoading();
}

class FeedLoaded extends FeedState {
  final List<Post> posts;
  const FeedLoaded(this.posts);
}

class FeedError extends FeedState {
  final String message;
  const FeedError(this.message);
}
