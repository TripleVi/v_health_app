import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../core/resources/style.dart';
import '../../widgets/app_bar.dart';
import '../cubit/statistics_cubit.dart';
import '../daily_activities/views/daily_activities.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatisticsCubit>(
      create: (context) => StatisticsCubit(),
      child: Navigator(
        onGenerateRoute: (settings) {
          if(settings.name == "/statistics") {
            return MaterialPageRoute<void>(
              builder: (context) => const StatisticsView(),
              settings: settings,
            );
          }
          if(settings.name == "/dailyActivities") {
            return MaterialPageRoute<void>(
              builder: (context) => const DailyActivities(),
              settings: settings,
            );
          }
          return null;
        },
        initialRoute: "/statistics",
      ),
    );
  }
}

class StatisticsView extends StatelessWidget {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.neutralColor,
      appBar: CustomAppBar.get(
        title: "Statistics",
      ),
      body: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppStyle.neutralColor400)),
        ),
        child: BlocBuilder<StatisticsCubit, StatisticsState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  todayGoalWidget(),
                  const SizedBox(height: 12.0),
                  sevenDaysGoalsWidget(context),
                ],
              ),
            );
          },
        ),
      )
    );
  }

  Widget todayGoalWidget() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppStyle.surfaceColor,
        borderRadius: BorderRadius.circular(AppStyle.borderRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32.0,
                    height: 32.0,
                    decoration: const BoxDecoration(
                      color: AppStyle.stepColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/images/activities/step.svg",
                        width: 20.0,
                        height: 20.0,
                        colorFilter: const ColorFilter
                            .mode(Colors.white, BlendMode.srcIn),
                        semanticsLabel: "step icon"
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Row(
                    textBaseline: TextBaseline.alphabetic,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: [
                      Text("0", style: AppStyle.heading3()),
                      const SizedBox(width: 2.0),
                      Text("step", style: AppStyle.caption1()),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32.0,
                    height: 32.0,
                    decoration: const BoxDecoration(
                      color: AppStyle.timeColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/images/activities/time.svg",
                        width: 20.0,
                        height: 20.0,
                        colorFilter: const ColorFilter
                            .mode(Colors.white, BlendMode.srcIn),
                        semanticsLabel: "time icon"
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Row(
                    textBaseline: TextBaseline.alphabetic,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: [
                      Text("0", style: AppStyle.heading3()),
                      const SizedBox(width: 2.0),
                      Text("minute", style: AppStyle.caption1()),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32.0,
                    height: 32.0,
                    decoration: const BoxDecoration(
                      color: AppStyle.calorieColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/images/activities/calorie.svg",
                        width: 20.0,
                        height: 20.0,
                        colorFilter: const ColorFilter
                            .mode(Colors.white, BlendMode.srcIn),
                        semanticsLabel: "calorie icon"
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Row(
                    textBaseline: TextBaseline.alphabetic,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: [
                      Text("0", style: AppStyle.heading4()),
                      const SizedBox(width: 2.0),
                      Text("kcal", style: AppStyle.caption1()),
                    ],
                  ),
                ],
              )
            ],
          ),
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
        ],
      ),
    );
  }

  Widget sevenDaysGoalsWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed<void>(context, "/dailyActivities");
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: AppStyle.surfaceColor,
          borderRadius: BorderRadius.circular(AppStyle.borderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Your Daily Goals", style: AppStyle.heading4()),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 20.0,
                  color: AppStyle.secondaryIconColor,
                )
              ],
            ),
            const SizedBox(height: 8.0),
            Text("7 days ago", style: AppStyle.caption1()),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("0/7", style: AppStyle.heading4()),
                    Text("Achieved", style: AppStyle.caption1()),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        goalProgressWidget(
                          stepsPercent: 0.4,
                          timePercent: 0.4,
                          caloriesPercent: 0.4,
                        ),
                        const SizedBox(height: 4.0),
                        Text("T2", style: AppStyle.caption1()),
                      ],
                    ),
                    const SizedBox(width: 4.0),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        goalProgressWidget(
                          stepsPercent: 0.4,
                          timePercent: 0.4,
                          caloriesPercent: 0.4,
                        ),
                        const SizedBox(height: 4.0),
                        Text("T3", style: AppStyle.caption1()),
                      ],
                    ),
                    const SizedBox(width: 4.0),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        goalProgressWidget(
                          stepsPercent: 0.4,
                          timePercent: 0.4,
                          caloriesPercent: 0.4,
                        ),
                        const SizedBox(height: 4.0),
                        Text("T4", style: AppStyle.caption1()),
                      ],
                    ),
                    const SizedBox(width: 4.0),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        goalProgressWidget(
                          stepsPercent: 0.4,
                          timePercent: 0.4,
                          caloriesPercent: 0.4,
                        ),
                        const SizedBox(height: 4.0),
                        Text("T5", style: AppStyle.caption1()),
                      ],
                    ),
                    const SizedBox(width: 4.0),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        goalProgressWidget(
                          stepsPercent: 0.4,
                          timePercent: 0.4,
                          caloriesPercent: 0.4,
                        ),
                        const SizedBox(height: 4.0),
                        Text("T6", style: AppStyle.caption1()),
                      ],
                    ),
                    const SizedBox(width: 4.0),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        goalProgressWidget(
                          stepsPercent: 0.4,
                          timePercent: 0.4,
                          caloriesPercent: 0.4,
                        ),
                        const SizedBox(height: 4.0),
                        Text("T7", style: AppStyle.caption1()),
                      ],
                    ),
                    const SizedBox(width: 4.0),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        goalProgressWidget(
                          stepsPercent: 0.4,
                          timePercent: 0.4,
                          caloriesPercent: 0.4,
                        ),
                        const SizedBox(height: 4.0),
                        Text("CN", style: AppStyle.caption1Bold()),
                      ],
                    ),
                  ],
                )
              ],
            )
          ],
        )
      ),
    );
  }

  Widget goalProgressWidget({
    double stepsPercent = 0.0,
    double timePercent = 0.0,
    double caloriesPercent = 0.0,
  }) {
    return CircularPercentIndicator(
      radius: 12.5,
      animation: true,
      animationDuration: 1200,
      lineWidth: 2.5,
      percent: stepsPercent,
      center: CircularPercentIndicator(
        radius: 9,
        animation: true,
        animationDuration: 1200,
        lineWidth: 2.5,
        percent: timePercent,
        center: CircularPercentIndicator(
          radius: 5.5,
          animation: true,
          animationDuration: 1200,
          lineWidth: 2.5,
          percent: caloriesPercent,
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
    );
  }
}