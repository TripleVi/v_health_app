import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../core/resources/style.dart';
import '../../views/metrics_progress.dart';
import 'cubit/calendar_cubit.dart';

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
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("March 2023", style: AppStyle.heading4()),
                      const SizedBox(height: 4.0),
                      Text("Goals achieved 0/30 days", style: AppStyle.bodyText()),
                      Row(
                        children: [
                          Text("100 steps", style: AppStyle.bodyText()),
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
                          Text("30 minutes", style: AppStyle.bodyText()),
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
                          Text("500 kcal", style: AppStyle.bodyText()),
                        ],
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop<void>(context),
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
            const SizedBox(height: 4.0),
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
            Expanded(
              child: SfDateRangePicker(
                backgroundColor: AppStyle.surfaceColor,
                onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                  print(dateRangePickerSelectionChangedArgs.value);
                },
                showTodayButton: true,
                controller: state.datePickerController,
                onViewChanged: (dateRangePickerViewChangedArgs) {
                  print(dateRangePickerViewChangedArgs.view);
                  // if(isVisible) {
                  //   Navigator.pop(context);
                  // }
                  // isVisible = true;
                },
                // monthCellStyle: DateRangePickerMonthCellStyle(text),
                // headerHeight: 0.0,
                selectionMode: DateRangePickerSelectionMode.single,
                view: DateRangePickerView.month,
                navigationDirection: DateRangePickerNavigationDirection.vertical,
                initialSelectedRange: PickerDateRange(DateTime.now(), null),
                // cellBuilder: (context, cellDetails) {
                //   return Column(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       cellDetails.date.isBefore(DateTime.now()) 
                //         ? const MetricsProgress(
                //           stepPercent: 0.4,
                //           durationPercent: 0.4,
                //           caloriePercent: 0.4,
                //         ).small 
                //         : const SizedBox(),
                //       const SizedBox(height: 2.0),
                //       Text("${cellDetails.date.day}"),
                //     ],
                //   );
                // },
              ),
            ),
          ],
        );
      },
    );
  }
}