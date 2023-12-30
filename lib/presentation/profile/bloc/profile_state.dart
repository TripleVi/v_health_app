part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {
  const ProfileState();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final User user;
  final int followers;
  final int followings;

  const ProfileLoaded({
    required this.user,
    required this.followings,
    required this.followers,
  });
}
