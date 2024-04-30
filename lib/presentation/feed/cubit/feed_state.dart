part of 'feed_cubit.dart';

@immutable
sealed class FeedState {}

final class FeedLoading extends FeedState {
  FeedLoading();
}

final class FeedRefreshed extends FeedState {
  FeedRefreshed();
}

final class FeedLoaded extends FeedState {
  final List<Post> posts;
  FeedLoaded(this.posts);
}

final class FeedError extends FeedState {
  final String message;
  FeedError(this.message);
}
