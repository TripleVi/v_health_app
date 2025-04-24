part of "post_cubit.dart";

@immutable
sealed class PostState {}

final class PostLoading extends PostState {}

final class PostLoaded extends PostState {
  final PostData data;
  late final String txtDate;
  late final List<int> time;
  final bool readMore;

  PostLoaded({
    required this.data,
    this.readMore = false,
  }) {
    txtDate = ta.format(data.post.createdDate, locale: "en");
    final rDuration = data.post.record.endDate
        .difference(data.post.record.startDate);
    final hours = rDuration.inHours;
    final minutes = rDuration.inMinutes - hours * 60;
    final seconds = rDuration.inSeconds - minutes * 60;
    time = [hours, minutes, seconds];        
  }

  PostLoaded copyWith({
    int? comments,
    bool? readMore,
  }) {
    return PostLoaded(
      data: data, 
      readMore: readMore ?? this.readMore,
    );
  }
}