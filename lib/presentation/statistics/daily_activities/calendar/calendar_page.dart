import "dart:math" as math;

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:syncfusion_flutter_datepicker/datepicker.dart";

import "../../../../core/resources/style.dart";
import "../../../../core/utilities/utils.dart";
import "../../../widgets/loading_indicator.dart";
import "../../views/metrics_progress.dart";
import "cubit/calendar_cubit.dart";

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CalendarCubit>(
      create: (context) => CalendarCubit(),
      child: const CalendarView(),
    );
  }
}

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CalendarHeader(key: GlobalKey<CalendarHeaderState>()),
        BlocBuilder<CalendarCubit, CalendarState>(
          builder: (context, state) {
            if(state is CalendarStateLoading) {
              return const Expanded(
                child: SizedBox(
                  height: 32.0, 
                  child: AppLoadingIndicator(),
                ),
              );
            }
            state as CalendarStateLoaded;
            return Expanded(
              child: SfDateRangePicker(
                // initialSelectedDate: DateTime.now(),
                backgroundColor: AppStyle.surfaceColor,
                onSelectionChanged: (dateChanged) => 
                    Navigator.pop<DateTime>(context, dateChanged.value),
                initialDisplayDate: DateTime.now(),
                maxDate: DateTime.now(),
                controller: state.controller,
                onViewChanged: (viewChangedArgs) {
                  context.read<CalendarCubit>()
                      .onViewChanged(viewChangedArgs.visibleDateRange.startDate!);
                },
                headerHeight: 0.0,
                selectionMode: DateRangePickerSelectionMode.single,
                view: DateRangePickerView.month,
                navigationDirection: DateRangePickerNavigationDirection.vertical,
                selectionColor: AppStyle.primaryColor50,
                monthCellStyle: const DateRangePickerMonthCellStyle(
                  todayTextStyle: TextStyle(color: AppStyle.primaryColor),
                ),
                cellBuilder: (context, cellDetails) {
                  if(cellDetails.date.isAfter(DateTime.now())) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("${cellDetails.date.day}", style: AppStyle.caption1()),
                      ],
                    );
                  }
                  final index = MyUtils
                      .monthsDifference(DateTime.now(), cellDetails.date);
                  final report = state.reports[index][cellDetails.date.day-1];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MetricsProgress(
                        stepPercent: math.min(report.steps/report.goal.steps, 1),
                        durationPercent: math
                            .min(report.activeTime/report.goal.activeTime, 1),
                        caloriePercent: math
                            .min(report.calories/report.goal.calories, 1),
                      ).small,
                      Text("${cellDetails.date.day}", style: AppStyle.caption1()),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class CalendarHeader extends StatefulWidget {
  const CalendarHeader({super.key});

  @override
  State<CalendarHeader> createState() => CalendarHeaderState();
}

class CalendarHeaderState extends State<CalendarHeader> {
  String title = "";
  int daysInMonth = 0;
  int steps = 0;
  int minutes = 0;
  int calories = 0;
  int goalsAchieved = 0;
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    context.read<CalendarCubit>()
        .setHeaderKey(widget.key as GlobalKey<CalendarHeaderState>);
  }

  void updateStateHelper({
    required String title,
    required int daysInMonth,
    required int steps,
    required int minutes,
    required int calories,
    required int goalsAchieved,
  }) async {
    if(!isVisible) {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      isVisible = true;
    }
    setState(() {
      this.title = title;
      this.daysInMonth = daysInMonth;
      this.steps = steps;
      this.minutes = minutes;
      this.calories = calories;
      this.goalsAchieved = goalsAchieved;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(!isVisible) return const SizedBox();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppStyle.heading4()),
                  const SizedBox(height: 4.0),
                  Text(
                    "Goals achieved $goalsAchieved/$daysInMonth days", 
                    style: AppStyle.bodyText(),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () =>  Navigator.pop<void>(context),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                  color: AppStyle.sBtnBgColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 20.0,
                  color: AppStyle.primaryIconColor,
                ),
              )
            ),
          ],
        ),
        Row(
          children: [
            Text("$steps steps", style: AppStyle.bodyText()),
            const SizedBox(width: 4.0),
            Container(
              width: 4.0,
              height: 4.0,
              decoration: const BoxDecoration(
                color: AppStyle.secondaryTextColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4.0),
            Text("$minutes minutes", style: AppStyle.bodyText()),
            const SizedBox(width: 4.0),
            Container(
              width: 4.0,
              height: 4.0,
              decoration: const BoxDecoration(
                color: AppStyle.secondaryTextColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4.0),
            Text("$calories kcal", style: AppStyle.bodyText()),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () => context.read<CalendarCubit>().moveBackward(),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(
                  Icons.keyboard_arrow_up_rounded,
                  size: 24.0,
                  color: AppStyle.secondaryIconColor,
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            GestureDetector(
              onTap: () => context.read<CalendarCubit>().moveForward(),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 24.0,
                  color: AppStyle.secondaryIconColor,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}