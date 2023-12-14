part of 'friend_cubit.dart';

@immutable
sealed class FriendState {
  const FriendState();
}

final class FriendLoading extends FriendState {
  const FriendLoading();
}

final class FriendLoaded extends FriendState {
  final User user;
  final List<Friend> friends;
  final bool isSearching;
  final bool isProcessing;
  final TextEditingController searchController;
  final String? snackMsg;

  const FriendLoaded({
    required this.user,
    this.friends = const [],
    this.isSearching = false,
    this.isProcessing = false,
    required this.searchController,
    this.snackMsg,
  });

  FriendLoaded copyWith({
    List<Friend>? friends,
    bool? isSearching,
    bool isProcessing = false,
    String? snackMsg,
  }) {
    return FriendLoaded(
      user: user,
      friends: friends ?? this.friends,
      isSearching: isSearching ?? this.isSearching,
      isProcessing: isProcessing,
      searchController: searchController,
      snackMsg: snackMsg,
    );
  }
}
