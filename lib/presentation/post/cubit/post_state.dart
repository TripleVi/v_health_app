part of "post_cubit.dart";

@immutable
sealed class PostState {}

final class PostLoading extends PostState {}

final class PostLoaded extends PostState {
  final PostData data;
  late final String txtDate;
  late final String recordTime;
  final bool readMore;

  PostLoaded({
    required this.data,
    this.readMore = false,
  }) {
    txtDate = ta.format(data.post.createdDate, locale: "en");
    final record = data.post.record;
    final rDuration = record.endDate.difference(record.startDate);
    recordTime = "";
    // final hours = rDuration.inHours;
    // final minutes = rDuration.inMinutes - rDuration.inHours * 60;
    // if(rDuration.inHours > 0) {
    //   recordTime = "$hours h";
    // }
    // if(rDuration.inMinutes > 0) {
    //   recordTime = "${recordTime.isEmpty ? "$recordTime " : ""}$minutes m";
    // }
    // if(rDuration.inSeconds <= 59) {
    //   recordTime = "${rDuration.inSeconds} s";
    // }        
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