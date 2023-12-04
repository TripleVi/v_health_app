part of 'saving_cubit.dart';

@immutable
sealed class SavingState {
  const SavingState();
}

final class SavingLoading extends SavingState {
  const SavingLoading();
}

final class SavingLoaded extends SavingState {
  final PostPrivacy privacy;
  final io.File map;
  final String titleHint;
  final bool isProcessing;
  final String? errorMsg;

  const SavingLoaded({
    required this.map,
    this.privacy = PostPrivacy.public,
    required this.titleHint,
    this.isProcessing = false,
    this.errorMsg,
  });

  SavingLoaded copyWith({
    PostPrivacy? privacy,
    io.File? map,
    bool isProcessing = false,
    String? errorMsg,
  }) {
    return SavingLoaded(
      privacy: privacy ?? this.privacy,
      map: map ?? this.map,
      titleHint: titleHint,
      isProcessing: isProcessing,
      errorMsg: errorMsg,
    );
  }
}

final class SavingSuccess extends SavingState {
  const SavingSuccess();
}