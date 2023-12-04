part of 'likes_cubit.dart';

@immutable
abstract class LikesState {
  const LikesState();
}

class LikesLoading extends LikesState {
  const LikesLoading();
}

class LikesLoaded extends LikesState {
  final List<Reaction> reactions;
  const LikesLoaded(this.reactions);
}
