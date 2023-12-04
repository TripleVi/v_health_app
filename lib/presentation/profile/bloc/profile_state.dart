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
  final io.File? avatarFile;
  const ProfileLoaded(this.user, this.avatarFile);
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);
}
