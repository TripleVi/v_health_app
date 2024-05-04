part of "profile_details_cubit.dart";

@immutable
sealed class ProfileDetailsState {}

final class ProfileDetailsLoading extends ProfileDetailsState {}

final class ProfileDetailsLoaded extends ProfileDetailsState {
  final User user;
  final String? snackMsg;

  ProfileDetailsLoaded({
    required this.user,
    this.snackMsg,
  });

  ProfileDetailsLoaded copyWith({
    User? user,
    String? snackMsg,
  }) {
    return ProfileDetailsLoaded(
      user: user ?? this.user,
      snackMsg: snackMsg,
    );
  }
}