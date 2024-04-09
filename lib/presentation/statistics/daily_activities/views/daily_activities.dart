import "dart:math" as math;

import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:intl/intl.dart";
import "package:syncfusion_flutter_charts/charts.dart";

import "../../../../core/enum/metrics.dart";
import "../../../../core/resources/style.dart";
import "../../../../core/utilities/utils.dart";
import "../../../../domain/entities/chart_data.dart";
import "../../../widgets/app_bar.dart";
import "../../../widgets/loading_indicator.dart";
import "../../views/metrics_progress.dart";
import "../calendar/calendar_page.dart";
import "../cubit/daily_activities_cubit.dart";
import "custom_chart.dart";

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
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      appBar: CustomAppBar.get(
        title: "Daily activities",
        actions: [
          IconButton(
            onPressed: () => openCalendar(context),
            icon: const Icon(Icons.calendar_month_rounded),
          ),
          IconButton(
            onPressed: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomChart(),));
              // Navigator.pushNamed(context, "/goalSettings");
              print("hello world");
              context.read<DailyActivitiesCubit>().fetchMonthlyActivitiesData();
            },
            icon: const Icon(Icons.settings_rounded),
          ),
        ],
      ),
      body: BlocBuilder<DailyActivitiesCubit, DailyActivitiesState>(
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
                const SizedBox(height: 12.0),
              ],
            );
          }
          if(state is WeeklyActivitiesLoaded) {
            // 0/7 goals achieved
            content = Column(
              children: [
                timeNavigation(context, state.timeType),
                const SizedBox(height: 12.0),
                summaryOfWeekWidget(context, state),
                const SizedBox(height: 12.0),
                metricsChartsByDay(state),
                const SizedBox(height: 12.0),
              ],
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 4.0,
            ),
            child: content,
          );
        },
      )
    );
  }

  Widget timeNavigation(BuildContext context, TimeType timeType) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        timeBtn(
          onTap: () {
            // context.read<DailyActivitiesCubit>().viewByDay();
            context.read<DailyActivitiesCubit>().fetchWeeklyActivitiesData();
          }, 
          content: "Day", 
          isSelected: timeType.isDay,
        ),
        timeBtn(
          onTap: () {
            context.read<DailyActivitiesCubit>().viewByWeek();
          }, 
          isSelected: timeType.isWeek,
          content: "Week",
        ),
        timeBtn(
          onTap: () {
            context.read<DailyActivitiesCubit>().viewByMonth();
          }, 
          content: "Month",
          isSelected: timeType.isMonth,
        ),
        timeBtn(
          onTap: () {
            context.read<DailyActivitiesCubit>().viewByYear();
          }, 
          content: "Year",
          isSelected: timeType.isYear,
        )
      ],
    );
  }

  Future<void> openCalendar(BuildContext context) {
    return showDialog<void>(
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
    );
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
                onTap: context.read<DailyActivitiesCubit>().previousDay,
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
            stepPercent: report.steps/report.goal.steps,
            durationPercent: report.activeTime/report.goal.activeTime,
            caloriePercent: report.calories/report.goal.calories,
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
                  value: report.calories,
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
                onTap: context.read<DailyActivitiesCubit>().previousDay,
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
              DateTime.now().add(const Duration(days: 7)).isAfter(state.endOfWeek)
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
            stepPercent: state.steps/state.stepsTarget,
            durationPercent: state.activeTime/state.activeTimeTarget,
            caloriePercent: state.calories/state.caloriesTarget,
          ).big,
          const SizedBox(height: 32.0),
          Row(
            children: [
              Expanded(
                child: metricsItemWidget(
                  content: "Steps",
                  value: state.steps,
                  subContent: "${state.stepsTarget}",
                  item: Metrics.step,
                ),
              ),
              Expanded(
                child: metricsItemWidget(
                  content: "Active time",
                  value: state.activeTime,
                  subContent: "${state.activeTimeTarget} minutes",
                  item: Metrics.time,
                ),
              ),
              Expanded(
                child: metricsItemWidget(
                  content: "Calories burnt",
                  value: state.calories,
                  subContent: "${state.caloriesTarget} kcal",
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
    required String subContent,
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
        Text("/$subContent", style: AppStyle.caption1()),
      ],
    );
  }

  Widget metricsChartsByHour(DailyActivitiesLoaded state) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppStyle.surfaceColor,
        borderRadius: BorderRadius.circular(AppStyle.borderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          metricsGraphByHour(
            title: "Steps",
            dataSource: state.hourlySteps,
            maxYAxis: state.maxStepsAxis,
            target: state.report.goal.steps,
            color: AppStyle.stepColor,
          ),
          const SizedBox(height: 40.0),
          metricsGraphByHour(
            title: "Active time",
            dataSource: state.hourlyActiveTime,
            maxYAxis: state.maxActiveTimeAxis,
            target: state.report.goal.activeTime,
            color: AppStyle.timeColor,
          ),
          const SizedBox(height: 40.0),
          metricsGraphByHour(
            title: "Calories burnt",
            dataSource: state.hourlyCalories,
            maxYAxis: state.maxCaloriesAxis,
            target: state.report.goal.calories,
            color: AppStyle.calorieColor,
          ),
        ],
      ),
    );
  }

  Widget metricsChartsByDay(WeeklyActivitiesLoaded state) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppStyle.surfaceColor,
        borderRadius: BorderRadius.circular(AppStyle.borderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          metricsGraphByHour(
            title: "Steps",
            dataSource: state.dailySteps,
            maxYAxis: state.maxStepsAxis,
            target: state.stepsTarget,
            color: AppStyle.stepColor,
          ),
          const SizedBox(height: 40.0),
          metricsGraphByHour(
            title: "Active time",
            dataSource: state.dailyActiveTime,
            maxYAxis: state.maxActiveTimeAxis,
            target: state.activeTimeTarget,
            color: AppStyle.timeColor,
          ),
          const SizedBox(height: 40.0),
          metricsGraphByHour(
            title: "Calories burnt",
            dataSource: state.dailyCalories,
            maxYAxis: state.maxCaloriesAxis,
            target: state.caloriesTarget,
            color: AppStyle.calorieColor,
          ),
        ],
      ),
    );
  }

  Widget metricsGraphByHour({
    required String title,
    required List<int> dataSource,
    required int maxYAxis,
    required int target,
    required Color color,
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
        tooltipBehavior: TooltipBehavior(enable: true),
        margin: const EdgeInsets.all(0.0),
        plotAreaBorderWidth: 0,
        axes: <ChartAxis>[
          NumericAxis(
            name: "xAxis",
            minimum: 0.0,
            maximum: 23.0,
            interval: 23.0,
            axisLine: const AxisLine(width: 0.0),
            tickPosition: TickPosition.outside,
            majorTickLines: const MajorTickLines(width: 0.0, size: 0.0),
            majorGridLines: const MajorGridLines(width: 0.0),
            labelPosition: ChartDataLabelPosition.inside,
            labelStyle: AppStyle.caption2(),
            axisLabelFormatter: (labelArgs) {
              return labelArgs.value == 0.0
                  ? ChartAxisLabel("", null)
                  : ChartAxisLabel("(hours)", labelArgs.textStyle);
            },
          ),
        ],
        primaryXAxis: CategoryAxis(
          minimum: 0.0,
          maximum: 23.0,
          interval: 4.0,
          majorTickLines: const MajorTickLines(
            color: AppStyle.secondaryTextColor,
          ),
          axisLine: const AxisLine(color: AppStyle.secondaryTextColor),
          majorGridLines: const MajorGridLines(width: 0.0),
          labelStyle: AppStyle.caption2(),
        ),
        primaryYAxis: NumericAxis(
          opposedPosition: true,
          decimalPlaces: 0,
          minimum: 0.0,
          maximum: maxYAxis*1.0,
          desiredIntervals: 2,
          majorTickLines: const MajorTickLines(width: 0.0, size: 0.0),
          axisLine: const AxisLine(width: 0.0),
          labelStyle: AppStyle.caption2(),
          axisLabelFormatter: (labelArgs) {
            return labelArgs.value == target
                ? ChartAxisLabel("", null)
                : ChartAxisLabel(labelArgs.text, labelArgs.textStyle);
          },
        ),
        series: <CartesianSeries<int, int>>[
          LineSeries(
            color: color,
            dataSource: const [0, 23],
            xValueMapper: (int data, index) => data,
            yValueMapper: (int data, _) => target,
            dashArray: const [3.0],
            xAxisName: "xAxis",
            dataLabelMapper: (datum, index) {
              return index == 0 ? null : "$target";
            },
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              margin: const EdgeInsets.all(0.0),
              textStyle: AppStyle.caption2(color: color),
            ),
          ),
          ColumnSeries(
            dataSource: dataSource,
            xValueMapper: (int data, index) => index,
            yValueMapper: (int data, _) => data,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppStyle.borderRadius),
              topRight: Radius.circular(AppStyle.borderRadius),
            ),
            color: AppStyle.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget metricsGraphByDay({
    required String title,
    required List<int> dataSource,
    required int maxYAxis,
    required int target,
    required Color color,
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
        tooltipBehavior: TooltipBehavior(enable: true),
        margin: const EdgeInsets.all(0.0),
        plotAreaBorderWidth: 0,
        axes: <ChartAxis>[
          NumericAxis(
            name: "xAxis",
            minimum: 0.0,
            maximum: 23.0,
            interval: 23.0,
            axisLine: const AxisLine(width: 0.0),
            tickPosition: TickPosition.outside,
            majorTickLines: const MajorTickLines(width: 0.0, size: 0.0),
            majorGridLines: const MajorGridLines(width: 0.0),
            labelPosition: ChartDataLabelPosition.inside,
            labelStyle: AppStyle.caption2(),
            axisLabelFormatter: (labelArgs) {
              return labelArgs.value == 0.0
                  ? ChartAxisLabel("", null)
                  : ChartAxisLabel("(hours)", labelArgs.textStyle);
            },
          ),
        ],
        primaryXAxis: CategoryAxis(
          minimum: 0.0,
          maximum: 23.0,
          interval: 4.0,
          majorTickLines: const MajorTickLines(
            color: AppStyle.secondaryTextColor,
          ),
          axisLine: const AxisLine(color: AppStyle.secondaryTextColor),
          majorGridLines: const MajorGridLines(width: 0.0),
          labelStyle: AppStyle.caption2(),
        ),
        primaryYAxis: NumericAxis(
          opposedPosition: true,
          decimalPlaces: 0,
          minimum: 0.0,
          maximum: maxYAxis*1.0,
          desiredIntervals: 2,
          majorTickLines: const MajorTickLines(width: 0.0, size: 0.0),
          axisLine: const AxisLine(width: 0.0),
          labelStyle: AppStyle.caption2(),
          axisLabelFormatter: (labelArgs) {
            return labelArgs.value == target
                ? ChartAxisLabel("", null)
                : ChartAxisLabel(labelArgs.text, labelArgs.textStyle);
          },
        ),
        series: <CartesianSeries<int, int>>[
          LineSeries(
            color: color,
            dataSource: const [0, 23],
            xValueMapper: (int data, index) => data,
            yValueMapper: (int data, _) => target,
            dashArray: const [3.0],
            xAxisName: "xAxis",
            dataLabelMapper: (datum, index) {
              return index == 0 ? null : "$target";
            },
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              margin: const EdgeInsets.all(0.0),
              textStyle: AppStyle.caption2(color: color),
            ),
          ),
          ColumnSeries(
            dataSource: dataSource,
            xValueMapper: (int data, index) => index,
            yValueMapper: (int data, _) => data,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppStyle.borderRadius),
              topRight: Radius.circular(AppStyle.borderRadius),
            ),
            color: AppStyle.primaryColor,
          ),
        ],
      ),
    );
  }
}