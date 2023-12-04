part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {
  const ProfileEvent();
}

class UserFetched extends ProfileEvent {
  const UserFetched();
}
