part of 'details_cubit.dart';

sealed class DetailsState {
  const DetailsState();
}

final class DetailsLoading extends DetailsState {
  const DetailsLoading();
}

final class DetailsLoaded extends DetailsState {
  final Post post;
  const DetailsLoaded(this.post);
}