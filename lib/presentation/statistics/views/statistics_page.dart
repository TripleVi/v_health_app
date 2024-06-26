import "dart:math" as math;

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/flutter_svg.dart";

import "../../../core/resources/style.dart";
import "../../../core/utilities/utils.dart";
import "../../widgets/app_bar.dart";
import "../../widgets/loading_indicator.dart";
import "../cubit/statistics_cubit.dart";
import "../daily_activities/goal_settings/goal_settings_page.dart";
import "../daily_activities/views/daily_activities.dart";
import "metrics_progress.dart";

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatisticsCubit>(
      create: (context) => StatisticsCubit(context),
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
          if(settings.name == "/goalSettings") {
            return MaterialPageRoute<void>(
              builder: (context) => const GoalSettingsPage(),
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
      backgroundColor: AppStyle.backgroundColor,
      appBar: CustomAppBar.get(
        title: "Statistics",
      ),
      body: BlocBuilder<StatisticsCubit, StatisticsState>(
        builder: (context, state) {
          if(state is StatisticsLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  todayGoalWidget(state),
                  const SizedBox(height: 12.0),
                  sevenDaysGoalsWidget(context, state),
                  const SizedBox(height: 12.0),
                  activitiesWidget(context, state),
                  const SizedBox(height: 12.0),
                  activeTimeWidget(context, state),
                ],
              ),
            );
          }
          return const SizedBox(
            height: 32.0, 
            child: AppLoadingIndicator(),
          );
        },
      )
    );
  }

  Widget todayGoalWidget(StatisticsLoaded state) {
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
                      Text("${state.today.steps}", style: AppStyle.heading4()),
                      const SizedBox(width: 2.0),
                      Text(
                        state.today.steps > 1 ? "steps" : "step", 
                        style: AppStyle.caption1(),
                      ),
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
                      Text("${state.today.activeTime < 60 ? state.today.activeTime : state.today.activeTime ~/ 60}", style: AppStyle.heading4()),
                      const SizedBox(width: 2.0),
                      Text(
                        state.today.activeTime < 60 ? "seconds" : state.today.activeTime > 1 ? "minutes" : "minute", 
                        style: AppStyle.caption1(),
                      ),
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
                      Text("${state.today.calories.ceil()}", style: AppStyle.heading4()),
                      const SizedBox(width: 2.0),
                      Text("kcal", style: AppStyle.caption1()),
                    ],
                  ),
                ],
              )
            ],
          ),
          MetricsProgress(
            stepPercent: math.min(state.today.steps/state.today.goal.steps, 1),
            durationPercent: math.min(state.today.activeTime/state.today.goal.activeTime, 1),
            caloriePercent: math.min(state.today.calories/state.today.goal.calories, 1),
          ).big,
        ],
      ),
    );
  }

  Widget sevenDaysGoalsWidget(BuildContext context, StatisticsLoaded state) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed<void>(context, "/dailyActivities"),
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
                Text("Your daily goals", style: AppStyle.heading4()),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 20.0,
                  color: AppStyle.secondaryIconColor,
                )
              ],
            ),
            const SizedBox(height: 8.0),
            Text("Last 7 days", style: AppStyle.caption1()),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${state.goalsAchieved}/7", 
                      style: AppStyle.heading4(color: AppStyle.primaryColor),
                    ),
                    Text(
                      "Achieved", 
                      style: AppStyle.caption1(color: AppStyle.primaryColor),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List<Widget>.generate(13, (index) {
                    if(index % 2 != 0) {
                      return const SizedBox(width: 4.0);
                    }
                    final report = state.recentReports[index~/2];
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MetricsProgress(
                          stepPercent: math.min(report.steps/report.goal.steps, 1),
                          durationPercent: math.min(report.activeTime/report.goal.activeTime, 1),
                          caloriePercent: math.min(report.calories/report.goal.calories, 1),
                        ).small(),
                        const SizedBox(height: 4.0),
                        Text(
                          MyUtils.getDateFirstLetter(report.date), 
                          style: index == 12
                              ? AppStyle.caption1(color: AppStyle.primaryColor)
                              : AppStyle.caption1(),
                        ),
                      ],
                    );
                  }),
                )
              ],
            )
          ],
        )
      ),
    );
  }

  Widget activitiesWidget(BuildContext context, StatisticsLoaded state) {
    return GestureDetector(
      // onTap: () => Navigator.pushNamed<void>(context, "/dailyActivities"),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: AppStyle.surfaceColor,
          borderRadius: BorderRadius.circular(AppStyle.borderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppStyle.sBtnBgColor
                        ),
                        child: const Icon(
                          Icons.directions_walk_rounded,
                          size: 24.0,
                          color: AppStyle.sBtnTextColor,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text("Waling", style: AppStyle.caption1()),
                    ],
                  ),
                ),
                GestureDetector(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppStyle.sBtnBgColor
                        ),
                        child: const Icon(
                          Icons.directions_run_rounded,
                          size: 24.0,
                          color: AppStyle.sBtnTextColor,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text("Running", style: AppStyle.caption1()),
                    ],
                  ),
                ),
                GestureDetector(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppStyle.sBtnBgColor
                        ),
                        child: const Icon(
                          Icons.directions_bike_rounded,
                          size: 24.0,
                          color: AppStyle.sBtnTextColor,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text("Cycling", style: AppStyle.caption1()),
                    ],
                  ),
                ),
              ],
            ),
          ],
        )
      ),
    );
  }

  Widget activeTimeWidget(BuildContext context, StatisticsLoaded state) {
    return GestureDetector(
      // onTap: () => Navigator.pushNamed<void>(context, "/dailyActivities"),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: AppStyle.surfaceColor,
          borderRadius: BorderRadius.circular(AppStyle.borderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Workout time this week", style: AppStyle.heading4()),
            const SizedBox(height: 12.0),
            Row(
              children: [
                const Icon(
                  Icons.access_time_filled,
                  size: 28.0,
                  color: AppStyle.timeColor,
                ),
                const SizedBox(width: 4.0),
                Text("00:00:00", style: AppStyle.heading5()),
              ],
            ),
          ],
        )
      ),
    );
  }
}