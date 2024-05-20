part of 'activity_cubit.dart';

@immutable
sealed class ActivityState {}

final class ActivityLoading extends ActivityState {}

final class ActivityLoaded extends ActivityState {
  final List<PostData> posts;
  final bool other;

  ActivityLoaded({
    required this.posts,
    required this.other,
  });
}
