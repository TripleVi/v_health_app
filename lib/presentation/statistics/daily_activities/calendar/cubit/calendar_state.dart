part of 'calendar_cubit.dart';

@immutable
sealed class CalendarState {}

final class CalendarStateLoading extends CalendarState {}

final class CalendarStateLoaded extends CalendarState {
  final DateRangePickerController controller;
  final List<List<DailyReport>> reports;

  CalendarStateLoaded({
    required this.controller,
    required this.reports,
  });

  CalendarStateLoaded copyWith({
    DateTime? startDate,
    List<List<DailyReport>>? reports,
  }) {
    return CalendarStateLoaded(
      controller: controller,
      reports: reports ?? this.reports,
    );
  }
}
