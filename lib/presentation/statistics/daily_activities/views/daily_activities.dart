import "dart:math" as math;

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:matrix2d/matrix2d.dart";
import "package:syncfusion_flutter_charts/charts.dart";
import "package:syncfusion_flutter_datepicker/datepicker.dart";

import "../../../../core/enum/metrics.dart";
import "../../../../core/resources/style.dart";
import "../../../../core/utilities/utils.dart";
import "../../../widgets/app_bar.dart";
import "../../../widgets/loading_indicator.dart";
import "../../views/metrics_progress.dart";
import "../calendar/calendar_page.dart";
import "../cubit/daily_activities_cubit.dart";

class DailyActivities extends StatelessWidget {
  const DailyActivities({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DailyActivitiesCubit>(
      create: (context) => DailyActivitiesCubit(),
      child: const DailyActivitiesView(),
    );
  }
}

class DailyActivitiesView extends StatelessWidget {
  const DailyActivitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyActivitiesCubit, DailyActivitiesState>(
      builder: (context, state) {
        if(state is DailyActivitiesLoading) {
          return const SizedBox(
            height: 32.0, 
            child: AppLoadingIndicator(),
          );
        }
        Widget content = const SizedBox();
        if(state is DailyActivitiesLoaded) {
          content = Column(
            children: [
              timeNavigation(context, state.timeType),
              const SizedBox(height: 12.0),
              summaryOfDayWidget(context, state),
              const SizedBox(height: 12.0),
              metricsChartsByHour(state),
            ],
          );
        }
        if(state is WeeklyActivitiesLoaded) {
          content = Column(
            children: [
              timeNavigation(context, state.timeType),
              const SizedBox(height: 12.0),
              summaryOfWeekWidget(context, state),
              const SizedBox(height: 12.0),
              metricsChartsByDay(state),
              const SizedBox(height: 12.0),
              daysOfWeekWidget(state),
            ],
          );
        }
        if(state is MonthlyActivitiesLoaded) {
          content = Column(
            children: [
              timeNavigation(context, state.timeType),
              const SizedBox(height: 12.0),
              summaryOfMonthWidget(context, state),
              const SizedBox(height: 12.0),
              metricsChartsByMonth(state),
              const SizedBox(height: 12.0),
            ],
          );
        }
        if(state is YearlyActivitiesLoaded) {
          content = Column(
            children: [
              timeNavigation(context, state.timeType),
              const SizedBox(height: 12.0),
              summaryOfYearWidget(context, state),
              const SizedBox(height: 12.0),
              metricsChartsByYear(state),
            ],
          );
        }
        return Scaffold(
          backgroundColor: AppStyle.backgroundColor,
          appBar: CustomAppBar.get(
            title: "Daily activities",
            actions: [
              state is WeeklyActivitiesLoaded 
                  ? const SizedBox() 
                  : IconButton(
                    onPressed: () {
                      if(state is DailyActivitiesLoaded) {
                        openDatePicker(context);
                      }else if(state is MonthlyActivitiesLoaded) {
                        openDurationPicker(
                          context: context, 
                          initialDate: state.startOfMonth,
                          view: DateRangePickerView.year, 
                          onDurationSelected: context
                              .read<DailyActivitiesCubit>().onMonthSelected,
                        );
                      }else if(state is YearlyActivitiesLoaded) {
                        openDurationPicker(
                          context: context, 
                          initialDate: DateTime(state.year),
                          view: DateRangePickerView.decade, 
                          onDurationSelected: context
                              .read<DailyActivitiesCubit>().onYearSelected,
                        );
                      }
                    },
                    icon: const Icon(Icons.calendar_month_rounded),
                  ),
              IconButton(
                onPressed: () => Navigator.pushNamed(context, "/goalSettings"),
                icon: const Icon(Icons.settings_rounded),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 4.0,
            ),
            child: content,
          ),
        );
      },
    );
  }

  Widget timeNavigation(BuildContext context, TimeType timeType) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        timeBtn(
          onTap: context.read<DailyActivitiesCubit>().viewByDay, 
          content: "Day", 
          isSelected: timeType.isDay,
        ),
        timeBtn(
          onTap: context.read<DailyActivitiesCubit>().viewByWeek, 
          isSelected: timeType.isWeek,
          content: "Week",
        ),
        timeBtn(
          onTap: context.read<DailyActivitiesCubit>().viewByMonth, 
          content: "Month",
          isSelected: timeType.isMonth,
        ),
        timeBtn(
          onTap: context.read<DailyActivitiesCubit>().viewByYear, 
          content: "Year",
          isSelected: timeType.isYear,
        )
      ],
    );
  }

  Future<void> openDatePicker(BuildContext context) {
    return showDialog<DateTime>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          backgroundColor: AppStyle.surfaceColor,
          surfaceTintColor: AppStyle.surfaceColor,
          insetPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 60),
          content: SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            child: CalendarPage(),
          ),
        );
      },
    ).then<void>(context.read<DailyActivitiesCubit>().onDateSelected);
  }

  Future<void> openDurationPicker({
    required BuildContext context,
    required DateTime initialDate,
    required DateRangePickerView view,
    required Future<void> Function(DateTime? startDate) onDurationSelected,
  }) {
    return showDialog<DateTime>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppStyle.surfaceColor,
          surfaceTintColor: AppStyle.surfaceColor,
          title: Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
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
              ),
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 24.0),
          insetPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 60.0),
          content: SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            child: SfDateRangePicker(
              backgroundColor: AppStyle.surfaceColor,
              todayHighlightColor: AppStyle.primaryColor,
              initialDisplayDate: initialDate,
              maxDate: DateTime.now(),
              onViewChanged: (viewChangedArgs) {
                if(viewChangedArgs.view != view) {
                  Navigator.pop<DateTime>(context, 
                      viewChangedArgs.visibleDateRange.startDate);
                }
              },
              headerStyle: DateRangePickerHeaderStyle(
                backgroundColor: AppStyle.surfaceColor, 
                textStyle: AppStyle.heading4(),
              ),
              selectionMode: DateRangePickerSelectionMode.single,
              view: view,
              navigationDirection: DateRangePickerNavigationDirection.vertical,
              yearCellStyle: const DateRangePickerYearCellStyle(
                todayTextStyle: TextStyle(color: AppStyle.primaryColor),
              ),
              monthCellStyle: const DateRangePickerMonthCellStyle(
                todayTextStyle: TextStyle(color: AppStyle.primaryColor),
              ),
            ),
          ),
        );
      },
    ).then<void>(onDurationSelected);
  }

  Widget timeBtn({
    required void Function() onTap,
    required String content,
    bool isSelected = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        constraints: const BoxConstraints(
          minWidth: 72.0,
          maxWidth: 84.0,
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppStyle.primaryColor.withOpacity(0.1) 
              : AppStyle.surfaceColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Text(
          content, 
          style: isSelected 
              ? AppStyle.caption1Bold(color: AppStyle.primaryColor)
              : AppStyle.caption1Bold(),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget summaryOfDayWidget(BuildContext context, DailyActivitiesLoaded state) {
    final report = state.report;
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppStyle.surfaceColor,
        borderRadius: BorderRadius.circular(AppStyle.borderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: context.read<DailyActivitiesCubit>().prevDay,
                child: const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20.0,
                    color: AppStyle.secondaryIconColor,
                  ),
                ),
              ),
              Text(
                MyUtils.getFormattedDate(report.date),
                style: AppStyle.heading4(),
              ),
              state.report.date.day == DateTime.now().day 
                  ? Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 20.0,
                        color: AppStyle.sIconDisabledColor,
                      ),
                    ) 
                  : GestureDetector(
                      onTap: context.read<DailyActivitiesCubit>().nextDay,
                      child: const Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20.0,
                          color: AppStyle.secondaryIconColor,
                        ),
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 32.0),
          MetricsProgress(
            stepPercent: math.min(report.steps/report.goal.steps, 1),
            durationPercent: math
                .min(report.activeTime/report.goal.activeTime, 1),
            caloriePercent: math
                .min(report.calories/report.goal.calories, 1),
          ).big,
          const SizedBox(height: 32.0),
          Row(
            children: [
              Expanded(
                child: metricsItemWidget(
                  content: "Steps",
                  value: report.steps,
                  subContent: "${report.goal.steps}",
                  item: Metrics.step,
                ),
              ),
              Expanded(
                child: metricsItemWidget(
                  content: "Active time",
                  value: report.activeTime,
                  subContent: "${report.goal.activeTime} minutes",
                  item: Metrics.time,
                ),
              ),
              Expanded(
                child: metricsItemWidget(
                  content: "Calories burnt",
                  value: report.calories.ceil(),
                  subContent: "${report.goal.calories} kcal",
                  item: Metrics.calorie,
                ),
              ),
            ],
          ),
        ],
      )
    );
  }

  Widget summaryOfWeekWidget(BuildContext context, WeeklyActivitiesLoaded state) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppStyle.surfaceColor,
        borderRadius: BorderRadius.circular(AppStyle.borderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: context.read<DailyActivitiesCubit>().prevWeek,
                child: const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20.0,
                    color: AppStyle.secondaryIconColor,
                  ),
                ),
              ),
              Text(
                MyUtils.getFormattedWeek(state.startOfWeek, state.endOfWeek),
                style: AppStyle.heading4(),
              ),
              state.startOfWeek.add(const Duration(days: 7)).isAfter(DateTime.now())
                  ? Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 20.0,
                        color: AppStyle.sIconDisabledColor,
                      ),
                    ) 
                  : GestureDetector(
                      onTap: context.read<DailyActivitiesCubit>().nextWeek,
                      child: const Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20.0,
                          color: AppStyle.secondaryIconColor,
                        ),
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 4.0),
          Text(
            "${state.goalsAchieved}/7 goals achieved", 
            style: AppStyle.bodyText(color: AppStyle.primaryColor),
          ),
          const SizedBox(height: 32.0),
          MetricsProgress(
            stepPercent: math.min(state.dailySteps.sum/state.totalStepsTarget, 1.0),
            durationPercent: math
                .min(state.dailyActiveTime.sum/state.totalActiveTimeTarget, 1.0),
            caloriePercent: math
                .min(state.dailyCalories.sum/state.totalCaloriesTarget, 1.0),
          ).big,
          const SizedBox(height: 32.0),
          Row(
            children: [
              Expanded(
                child: metricsItemWidget(
                  content: "Steps",
                  value: state.dailySteps.sum,
                  subContent: "${state.totalStepsTarget}",
                  item: Metrics.step,
                ),
              ),
              Expanded(
                child: metricsItemWidget(
                  content: "Active time",
                  value: state.dailyActiveTime.sum,
                  subContent: "${state.totalActiveTimeTarget} minutes",
                  item: Metrics.time,
                ),
              ),
              Expanded(
                child: metricsItemWidget(
                  content: "Calories burnt",
                  value: state.dailyCalories.sum,
                  subContent: "${state.totalCaloriesTarget} kcal",
                  item: Metrics.calorie,
                ),
              ),
            ],
          ),
        ],
      )
    );
  }

  Widget metricsItemWidget({
    required String content,
    required int value,
    String? subContent,
    required Metrics item,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(content, style: AppStyle.caption2()),
        const SizedBox(height: 4.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              item.assetName!,
              width: 12.0,
              height: 12.0,
              colorFilter: ColorFilter
                  .mode(item.color, BlendMode.srcIn),
              semanticsLabel: "${item.name} icon"
            ),
            const SizedBox(width: 2.0),
            Text("$value", style: AppStyle.heading4())
          ],
        ),
        subContent == null 
            ? const SizedBox() 
            : Text("/$subContent", style: AppStyle.caption1()),
      ],
    );
  }

  Widget metricsChartsByHour(DailyActivitiesLoaded state) {
    String toolTipLabel(int startHour) {
      final endHour = (startHour+1)%24;
      return "${startHour~/10}${startHour%10}:00 - ${endHour~/10}${endHour%10}:00";
    }
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppStyle.surfaceColor,
        borderRadius: BorderRadius.circular(AppStyle.borderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 40.0),
          metricsChart(
            title: "Steps", 
            dataSource: state.hourlySteps, 
            maxYAxis: state.maxStepsAxis, 
            seriesColor: AppStyle.stepColor, 
            unit: "steps",
            interval: 4,
            toolTipLabel: toolTipLabel,
          ),
          const SizedBox(height: 40.0),
          metricsChart(
            title: "Active time", 
            dataSource: state.hourlyActiveTime, 
            maxYAxis: state.maxActiveTimeAxis, 
            seriesColor: AppStyle.timeColor, 
            unit: "minutes",
            interval: 4,
            toolTipLabel: toolTipLabel,
          ),
          const SizedBox(height: 40.0),
          metricsChart(
            title: "Calories burnt", 
            dataSource: state.hourlyCalories, 
            maxYAxis: state.maxCaloriesAxis, 
            seriesColor: AppStyle.calorieColor, 
            interval: 4,
            unit: "kcal",
            toolTipLabel: toolTipLabel,
          ),
        ],
      ),
    );
  }

  Widget metricsChartsByDay(WeeklyActivitiesLoaded state) {
    String xAxisLabelText(int index) {
      final date = state.startOfWeek.add(Duration(days: index));
      return MyUtils.getDateFirstLetter(date);
    }
    String toolTipLabel(int index) {
      final aDay = state.startOfWeek.add(Duration(days: index));
      final bDay = aDay.add(const Duration(days: 1));
      return "${MyUtils.getFormattedWeekday(aDay)} - ${MyUtils.getFormattedWeekday(bDay)}";
    }
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppStyle.surfaceColor,
        borderRadius: BorderRadius.circular(AppStyle.borderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          metricsChart(
            title: "Steps", 
            dataSource: state.dailySteps, 
            maxYAxis: state.maxStepsAxis, 
            seriesColor: AppStyle.stepColor, 
            unit: "steps",
            target: state.stepsTarget,
            xAxisLabel: "day",
            xAxisLabelText: xAxisLabelText,
            toolTipLabel: toolTipLabel,
          ),
          const SizedBox(height: 40.0),
          metricsChart(
            title: "Active time", 
            dataSource: state.dailyActiveTime, 
            maxYAxis: state.maxActiveTimeAxis, 
            seriesColor: AppStyle.timeColor,
            unit: "minutes",
            target: state.activeTimeTarget,
            xAxisLabel: "day",
            xAxisLabelText: xAxisLabelText,
            toolTipLabel: toolTipLabel,
          ),
          const SizedBox(height: 40.0),
          metricsChart(
            title: "Calories burnt", 
            dataSource: state.dailyCalories, 
            maxYAxis: state.maxCaloriesAxis, 
            seriesColor: AppStyle.calorieColor,
            unit: "kcal",
            target: state.caloriesTarget,
            xAxisLabel: "day",
            xAxisLabelText: xAxisLabelText,
            toolTipLabel: toolTipLabel,
          ),
        ],
      ),
    );
  }

  Widget daysOfWeekWidget(WeeklyActivitiesLoaded state) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppStyle.surfaceColor,
        borderRadius: BorderRadius.circular(AppStyle.borderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(7, (index) {
          final date = state.startOfWeek.add(Duration(days: index));
          return ListTile(
            onTap: null,
            title: Text(
              MyUtils.getFormattedDate(date), 
              style: AppStyle.heading5(),
            ),
            subtitle: Row(
              children: [
                Text("${state.dailySteps[index]} steps", style: AppStyle.caption1()),
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
                Text("${state.dailyActiveTime[index]} minutes", style: AppStyle.caption1()),
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
                Text("${state.dailyCalories[index]} kcal", style: AppStyle.caption1()),
              ],
            ),
            trailing: state.daysAchievedGoals[index] == 1 ? const Icon(
              Icons.done_outline_rounded, 
              size: 20.0, 
              color: AppStyle.primaryColor,
            ) : null,
          );
        }),
      ),
    );
  }

  Widget summaryOfMonthWidget(BuildContext context, MonthlyActivitiesLoaded state) {
    final days = DateUtils.getDaysInMonth(state.startOfMonth.year, state.startOfMonth.month);
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppStyle.surfaceColor,
        borderRadius: BorderRadius.circular(AppStyle.borderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: context.read<DailyActivitiesCubit>().prevMonth,
                child: const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20.0,
                    color: AppStyle.secondaryIconColor,
                  ),
                ),
              ),
              Text(
                MyUtils.getFormattedMonth(state.startOfMonth),
                style: AppStyle.heading4(),
              ),
              state.startOfMonth.add(const Duration(days: 30)).isAfter(DateTime.now())
                  ? Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 20.0,
                        color: AppStyle.sIconDisabledColor,
                      ),
                    ) 
                  : GestureDetector(
                      onTap: context.read<DailyActivitiesCubit>().nextMonth,
                      child: const Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20.0,
                          color: AppStyle.secondaryIconColor,
                        ),
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 4.0),
          Text(
            "${state.goalsAchieved}/$days goals achieved", 
            style: AppStyle.bodyText(color: AppStyle.primaryColor),
          ),
          const SizedBox(height: 32.0),
          Row(
            children: [
              Expanded(
                child: metricsItemWidget(
                  content: "Steps",
                  value: state.dailySteps.sum,
                  item: Metrics.step,
                ),
              ),
              Expanded(
                child: metricsItemWidget(
                  content: "Active time",
                  value: state.dailyActiveTime.sum,
                  item: Metrics.time,
                ),
              ),
              Expanded(
                child: metricsItemWidget(
                  content: "Calories burnt",
                  value: state.dailyCalories.sum,
                  item: Metrics.calorie,
                ),
              ),
            ],
          ),
        ],
      )
    );
  }

  Widget summaryOfYearWidget(BuildContext context, YearlyActivitiesLoaded state) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppStyle.surfaceColor,
        borderRadius: BorderRadius.circular(AppStyle.borderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: context.read<DailyActivitiesCubit>().prevYear,
                child: const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20.0,
                    color: AppStyle.secondaryIconColor,
                  ),
                ),
              ),
              Text("${state.year}", style: AppStyle.heading4()),
              state.year == DateTime.now().year
                  ? Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 20.0,
                        color: AppStyle.sIconDisabledColor,
                      ),
                    ) 
                  : GestureDetector(
                      onTap: context.read<DailyActivitiesCubit>().nextYear,
                      child: const Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20.0,
                          color: AppStyle.secondaryIconColor,
                        ),
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 4.0),
          Text(
            "${state.goalsAchieved}/${MyUtils.getDaysInYear(state.year)} goals achieved", 
            style: AppStyle.bodyText(color: AppStyle.primaryColor),
          ),
          const SizedBox(height: 32.0),
          Row(
            children: [
              Expanded(
                child: metricsItemWidget(
                  content: "Steps",
                  value: state.monthlySteps.sum,
                  item: Metrics.step,
                ),
              ),
              Expanded(
                child: metricsItemWidget(
                  content: "Active time",
                  value: state.monthlyActiveTime.sum,
                  item: Metrics.time,
                ),
              ),
              Expanded(
                child: metricsItemWidget(
                  content: "Calories burnt",
                  value: state.monthlyCalories.sum,
                  item: Metrics.calorie,
                ),
              ),
            ],
          ),
        ],
      )
    );
  }

  Widget metricsChartsByMonth(MonthlyActivitiesLoaded state) {
    String xAxisLabelText(int index) => "${index+1}";
    String toolTipLabel(int index) {
      return "${index+1}${MyUtils.getOrdinalIndicator(index+1)} - ${index+2}${MyUtils.getOrdinalIndicator(index+2)}";
    }
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppStyle.surfaceColor,
        borderRadius: BorderRadius.circular(AppStyle.borderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          metricsChart(
            title: "Steps", 
            dataSource: state.dailySteps, 
            maxYAxis: state.maxStepsAxis, 
            seriesColor: AppStyle.stepColor, 
            interval: 7,
            unit: "steps",
            target: state.stepsTarget,
            xAxisLabelText: xAxisLabelText,
            toolTipLabel: toolTipLabel,
          ),
          const SizedBox(height: 40.0),
          metricsChart(
            title: "Active time", 
            dataSource: state.dailyActiveTime, 
            maxYAxis: state.maxActiveTimeAxis, 
            seriesColor: AppStyle.timeColor, 
            interval: 7,
            unit: "minutes",
            target: state.activeTimeTarget,
            xAxisLabelText: xAxisLabelText,
            toolTipLabel: toolTipLabel,
          ),
          const SizedBox(height: 40.0),
          metricsChart(
            title: "Calories burnt", 
            dataSource: state.dailyCalories, 
            maxYAxis: state.maxCaloriesAxis, 
            seriesColor: AppStyle.calorieColor, 
            interval: 7,
            unit: "kcal",
            target: state.caloriesTarget,
            xAxisLabelText: xAxisLabelText,
            toolTipLabel: toolTipLabel,
          ),
        ],
      ),
    );
  }

  Widget metricsChartsByYear(YearlyActivitiesLoaded state) {
    String xAxisLabelText(int index) => "${index+1}";
    String toolTipLabel(int index) => "${MyUtils.getMonthThreeLetter(index+1)} - ${MyUtils.getMonthThreeLetter(index+2)}";
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppStyle.surfaceColor,
        borderRadius: BorderRadius.circular(AppStyle.borderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          metricsChart(
            title: "Steps",
            dataSource: state.monthlySteps,
            maxYAxis: state.maxStepsAxis,
            seriesColor: AppStyle.stepColor,
            unit: "steps",
            xAxisLabelText: xAxisLabelText,
            toolTipLabel: toolTipLabel,
          ),
          const SizedBox(height: 40.0),
          metricsChart(
            title: "Active time",
            dataSource: state.monthlyActiveTime,
            maxYAxis: state.maxActiveTimeAxis,
            seriesColor: AppStyle.timeColor,
            unit: "minutes",
            xAxisLabelText: xAxisLabelText,
            toolTipLabel: toolTipLabel,
          ),
          const SizedBox(height: 40.0),
          metricsChart(
            title: "Calories burnt",
            dataSource: state.monthlyCalories,
            maxYAxis: state.maxCaloriesAxis,
            seriesColor: AppStyle.calorieColor,
            unit: "kcal",
            xAxisLabelText: xAxisLabelText,
            toolTipLabel: toolTipLabel,
          ),
        ],
      ),
    );
  }
  
  Widget metricsChart({
    required String title,
    required List<int> dataSource,
    required int maxYAxis,
    required Color seriesColor,
    double interval = 1,
    required String unit,
    int? target,
    String? xAxisLabel,
    String Function(int index)? xAxisLabelText,
    required String Function(int index) toolTipLabel,
  }) {
    return SizedBox(
      height: 200.0,
      child: SfCartesianChart(
        backgroundColor: AppStyle.surfaceColor,
        title: ChartTitle(
          text: title, 
          textStyle: AppStyle.heading5(),
          alignment: ChartAlignment.near,
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          color: AppStyle.backgroundColor,
          borderWidth: 0.0,
          opacity: 0.9,
          builder: (data, point, series, pointIndex, seriesIndex) {
            final label = toolTipLabel(pointIndex);
            return Container(
              padding: const EdgeInsets.all(4.0),
              color: AppStyle.backgroundColor,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: AppStyle.caption2(color: AppStyle.primaryTextColor),
                  ),
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
                  Text("$data $unit", style: AppStyle.caption1(color: series.color!)),
                ],
              ),
            );
          },
        ),
        margin: const EdgeInsets.all(0.0),
        plotAreaBorderWidth: 0.0,
        axes: <ChartAxis>[
          NumericAxis(
            isVisible: xAxisLabel != null,
            name: "xAxis",
            maximum: dataSource.length*1.0-1,
            interval: dataSource.length*1.0-1,
            axisLine: const AxisLine(width: 0.0),
            tickPosition: TickPosition.outside,
            majorTickLines: const MajorTickLines(width: 0.0, size: 0.0),
            majorGridLines: const MajorGridLines(width: 0.0),
            labelPosition: ChartDataLabelPosition.inside,
            labelStyle: AppStyle.caption2(),
            axisLabelFormatter: (labelArgs) {
              return labelArgs.value == 0.0
                  ? ChartAxisLabel("", null)
                  : ChartAxisLabel("($xAxisLabel)", labelArgs.textStyle);
            },
          ),
        ],
        primaryXAxis: CategoryAxis(
          interval: interval,
          majorTickLines: const MajorTickLines(
              color: AppStyle.secondaryTextColor,),
          axisLine: const AxisLine(color: AppStyle.secondaryTextColor),
          majorGridLines: const MajorGridLines(width: 0.0),
          labelStyle: AppStyle.caption2(),
          axisLabelFormatter: xAxisLabelText == null 
              ? null 
              : (labelArgs) {
                final txt = xAxisLabelText(labelArgs.value.toInt());
                return ChartAxisLabel(txt, labelArgs.textStyle);
              },
        ),
        primaryYAxis: NumericAxis(
          opposedPosition: true,
          decimalPlaces: 0,
          // minimum: 0.0,
          // maximum: maxYAxis*1.0,
          // desiredIntervals: 2,
          majorTickLines: const MajorTickLines(width: 0.0, size: 0.0),
          axisLine: const AxisLine(width: 0.0),
          labelStyle: AppStyle.caption2(),
          axisLabelFormatter: (labelArgs) {
            return ChartAxisLabel(
              MyUtils.getCompactNumberFormat(labelArgs.value), 
              labelArgs.textStyle,
            );
          },
        ),
        series: <CartesianSeries<int, int>>[
          ColumnSeries(
            dataSource: dataSource,
            xValueMapper: (data, index) => index,
            yValueMapper: (data, _) => data,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppStyle.borderRadius),
              topRight: Radius.circular(AppStyle.borderRadius),
            ),
            color: seriesColor,
          ),
          target == null 
              ? LineSeries(
                xValueMapper: (data, _) => null,
                yValueMapper: (data, _) => null,
                xAxisName: "xAxis",
              )
              : LineSeries(
                enableTooltip: false,
                color: AppStyle.primaryColor,
                dataSource: [0, dataSource.length-1],
                xValueMapper: (data, _) => data,
                yValueMapper: (data, _) => target,
                dashArray: const [3.0],
                xAxisName: "xAxis",
                dataLabelMapper: (datum, index) {
                  return index == 0 ? null : "$target";
                },
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  margin: const EdgeInsets.all(0.0),
                  textStyle: AppStyle.caption2(color: seriesColor),
                ),
              ),
        ],
      ),
    );
  }
}