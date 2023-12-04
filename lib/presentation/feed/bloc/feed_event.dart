part of 'feed_bloc.dart';

@immutable
abstract class FeedEvent {
  const FeedEvent();
}

class PostsFetched extends FeedEvent {
  final List<Post> posts;
  const PostsFetched(this.posts);
}