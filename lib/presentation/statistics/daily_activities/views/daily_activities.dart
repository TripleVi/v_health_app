import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../core/resources/style.dart';
import '../../../../core/utilities/utils.dart';
import '../../../../domain/entities/chart_data.dart';
import '../../../widgets/app_bar.dart';
import '../cubit/daily_activities_cubit.dart';

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
      backgroundColor: AppStyle.neutralColor,
      appBar: CustomAppBar.get(
        title: "Daily activities",
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppStyle.neutralColor400)),
        ),
        child: BlocBuilder<DailyActivitiesCubit, DailyActivitiesState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 4.0,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      timeBtn(
                        onTap: () {
                        
                        }, 
                        content: "Day", 
                        isSelected: true,
                      ),
                      timeBtn(
                        onTap: () {
                        
                        }, 
                        content: "Week",
                      ),
                      timeBtn(
                        onTap: () {
                        
                        }, 
                        content: "Month",
                      ),
                      timeBtn(
                        onTap: () {
                        
                        }, 
                        content: "Year",
                      )
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20.0,
                        color: AppStyle.neutralColor400,
                      ),
                      GestureDetector(
                        onTap: () {
    //                       showDatePicker(
    //   context: context,
    //   initialDate: DateTime.now(),
    //   firstDate: DateTime(2020, 1),
    //   lastDate: DateTime(2025, 12),
    //   helpText: 'Select a Date',
    //   builder: (context, child) {
        
    //   },
    // );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                          decoration: BoxDecoration(
                            color: AppStyle.surfaceColor,
                            borderRadius: BorderRadius.circular(16.0)
                          ),
                          child: Text(
                            "Monday, April 3", 
                            style: AppStyle.heading4(),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 20.0,
                        color: AppStyle.neutralColor400,
                      )
                    ],
                  ),
                  datePickerWidget(),
                  const SizedBox(height: 24.0),
                  summaryOfDayWidget(),
                  const SizedBox(height: 12.0),
                  metricsCharts(),
                  const SizedBox(height: 12.0),
                ],
              ),
            );
          },
        ),
      )
    );
  }

  Widget timeBtn({
    required void Function() onTap,
    required String content,
    bool isSelected = false,
  }) {
    return GestureDetector(
      onTap: () {
        
      },
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

  Widget summaryOfDayWidget() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppStyle.surfaceColor,
        borderRadius: BorderRadius.circular(AppStyle.borderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 32.0),
          CircularPercentIndicator(
            radius: 60.0,
            animation: true,
            animationDuration: 1200,
            lineWidth: 12.0,
            percent: 0.4,
            center: CircularPercentIndicator(
              radius: 46.0,
              animation: true,
              animationDuration: 1200,
              lineWidth: 12.0,
              percent: 0.4,
              center: CircularPercentIndicator(
                radius: 32.0,
                animation: true,
                animationDuration: 1200,
                lineWidth: 12.0,
                percent: 0.4,
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: AppStyle.calorieColor.withOpacity(0.2),
                progressColor: AppStyle.calorieColor,
              ),
              circularStrokeCap: CircularStrokeCap.round,
              backgroundColor: AppStyle.timeColor.withOpacity(0.2),
              progressColor: AppStyle.timeColor,
            ),
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: AppStyle.stepColor.withOpacity(0.2),
            progressColor: AppStyle.stepColor,
          ),
          const SizedBox(height: 32.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              metricsItemWidget(
                content: "Steps",
                metricsName: "step",
                value: 30,
                target: 1000,
                color: AppStyle.stepColor,
              ),
              metricsItemWidget(
                content: "Active time",
                metricsName: "time",
                value: 30,
                target: 90,
                color: AppStyle.timeColor,
              ),
              metricsItemWidget(
                content: "Calories Burnt",
                metricsName: "calorie",
                value: 100,
                target: 500,
                color: AppStyle.calorieColor,
              )
            ],
          )
        ],
      )
    );
  }

  Widget datePickerWidget() {
    return SfDateRangePicker(
      onSelectionChanged: null,
      selectionMode: DateRangePickerSelectionMode.single,
      view: DateRangePickerView.month,
      initialSelectedRange: PickerDateRange(
        DateTime.now(),
        null
      ),
      cellBuilder: (context, cellDetails) {
        return Container(
          width: 10.0,
          height: 10.0,
          color: Colors.yellow,
        );
      },
    );
  }

  Widget metricsItemWidget({
    required String content,
    required metricsName,
    required int value,
    required int target,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(content, style: AppStyle.caption1()),
        const SizedBox(height: 4.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/activities/$metricsName.svg",
              width: 12.0,
              height: 12.0,
              colorFilter: ColorFilter
                  .mode(color, BlendMode.srcIn),
              semanticsLabel: "$metricsName icon"
            ),
            const SizedBox(width: 2.0),
            Text("$value", style: AppStyle.heading4())
          ],
        ),
        Text("/$target", style: AppStyle.bodyText(height: 1.0)),
      ],
    );
  }

  Widget metricsCharts() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppStyle.surfaceColor,
        borderRadius: BorderRadius.circular(AppStyle.borderRadius),
      ),
      child: Column(
        children: [
          stepsGraphByHour(),
        ],
      ),
    );
  }

  Widget stepsGraphByHour() {
    final chartData = List<ChartData>.generate(24, (index) {
      final rng = math.Random();
      return ChartData.hourlyDataMockup(index, rng.nextInt(1000));
    });
    return SizedBox(

      child: SfCartesianChart(
        margin: const EdgeInsets.all(0),
        plotAreaBorderWidth: 0,
        primaryXAxis: const CategoryAxis(
          minimum: 0,
          maximum: 23,
          majorTickLines: MajorTickLines(color: AppStyle.neutralColor400),
          tickPosition: TickPosition.inside,
          axisLine: AxisLine(color: AppStyle.neutralColor400),
          majorGridLines: MajorGridLines(width: 0),
          labelStyle: TextStyle(color: AppStyle.neutralColor400),
        ),
        primaryYAxis: CategoryAxis(
          isVisible: false,
          minimum: 0,
          maximum: MyUtils.getMaxValue(chartData),
        ),
        series: <CartesianSeries<ChartData, int>>[
          ColumnSeries<ChartData, int>(
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            width: 1,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            color: Colors.red,
            spacing: 0.1
          ),
        ]
      ),
    );
  }
}