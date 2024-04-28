part of 'details_cubit.dart';

sealed class DetailsState {
  const DetailsState();
}

final class DetailsLoading extends DetailsState {
  const DetailsLoading();
}

final class DetailsLoaded extends DetailsState {
  final Post post;
  final List<int> times;
  final List<double> speeds;
  final double avgSpeed;
  final List<double> paces;
  final double avgPace;

  const DetailsLoaded({
    required this.post,
    required this.times,
    required this.speeds,
    required this.avgSpeed,
    required this.paces,
    required this.avgPace,
  });
}

final class DetailsError extends DetailsState {
  const DetailsError();
}