part of 'details_cubit.dart';

abstract class DetailsState {
  const DetailsState();
}

class DetailsLoading extends DetailsState {
  const DetailsLoading();
}

class DetailsLoaded extends DetailsState {
  final Post post;
  const DetailsLoaded(this.post);
}

class DetailsError extends DetailsState {
  final String message;
  const DetailsError(this.message);
}