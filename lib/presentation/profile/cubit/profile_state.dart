part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {
  ProfileInitial();
}

final class ProfileLoading extends ProfileState {
  final User user;

  ProfileLoading(this.user);
}

class ProfileLoaded extends ProfileState {
  final User user;
  final int followers;
  final int followings;
  final int posts;

  ProfileLoaded({
    required this.user,
    required this.followings,
    required this.followers,
    required this.posts,
  });
}
