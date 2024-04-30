part of "likes_cubit.dart";

@immutable
sealed class LikesState {
  const LikesState();
}

class LikesLoading extends LikesState {
  const LikesLoading();
}

class LikesLoaded extends LikesState {
  final User user;
  final List<Reaction> reactions;
  final String? snackMsg;

  const LikesLoaded({
    required this.user, 
    required this.reactions,
    this.snackMsg,
  });

  LikesLoaded copyWith({
    String? snackMsg,
  }) {
    return LikesLoaded(
      user: user,
      reactions: reactions,
      snackMsg: snackMsg,
    );
  }
}
