import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_picker/flutter_picker.dart";
import "package:flutter_svg/flutter_svg.dart";

import "../../../../core/enum/metrics.dart";
import "../../../../core/resources/style.dart";
import "../../../widgets/app_bar.dart";
import "../../../widgets/loading_indicator.dart";
import "cubit/goal_settings_cubit.dart";

class GoalSettingsPage extends StatelessWidget {
  const GoalSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GoalSettingsCubit>(
      create: (context) => GoalSettingsCubit(),
      child: const GoalSettingsView(),
    );
  }
}

class GoalSettingsView extends StatelessWidget {
  const GoalSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      appBar: CustomAppBar.get(
        title: "Goal settings",
      ),
      body: BlocBuilder<GoalSettingsCubit, GoalSettingsState>(
        builder: (context, state) {
          if(state is GoalSettingsLoading) {
            return const SizedBox(
              height: 32.0, 
              child: AppLoadingIndicator(),
            ); 
          }
          state as GoalSettingsLoaded;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 4.0,
            ),
            child: Column(
              children: [
                metricsCard(context, state),
              ],
            ),
          );
        },
      )
    );
  }

  Widget metricsCard(BuildContext context, GoalSettingsLoaded state) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppStyle.surfaceColor,
        borderRadius: BorderRadius.circular(AppStyle.borderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          metricsTile(
            context: context, 
            item: Metrics.step, 
            value: state.dailyGoal.steps, 
            onTap: () => showPickerNumber(
              context: context,
              title: "Steps",
              description: "How many steps do you want to take in a day?",
              begin: 1000,
              end: 50000,
              jump: 100,
              initial: state.dailyGoal.steps,
              number: 0,
            ),
          ),
          metricsTile(
            context: context, 
            item: Metrics.time, 
            value: state.dailyGoal.activeTime, 
            onTap: () =>  showPickerNumber(
              context: context,
              title: "Time",
              description: "How many minutes do you want to be active in a day?",
              begin: 30,
              end: 360,
              jump: 10,
              initial: state.dailyGoal.activeTime,
              number: 1,
            ),
          ),
          metricsTile(
            context: context, 
            item: Metrics.calorie, 
            value: state.dailyGoal.calories,
            onTap: () => showPickerNumber(
              context: context,
              title: "Calories",
              description: "How many kilocalories do you want to burn in a day?",
              begin: 100,
              end: 50000,
              jump: 10,
              initial: state.dailyGoal.calories,
              number: 2,
            ),
          ),
        ]
      )
    );
  }

  Widget metricsTile({
    required BuildContext context, 
    required Metrics item, 
    required int value, 
    required void Function() onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: SvgPicture.asset(
        item.assetName!,
        width: 24.0,
        height: 24.0,
        colorFilter: ColorFilter.mode(item.color, BlendMode.srcIn),
        semanticsLabel: "${item.name} icon"
      ),
      title: Text(item.name, style: AppStyle.heading5()),
      subtitle: Text(
        "$value ${item.unit}",
        style: AppStyle.caption1(),
      ),
      trailing: const Icon(
        Icons.settings_rounded, 
        size: 20.0, 
        color: AppStyle.secondaryIconColor,
      ),
    );
  }

  showPickerNumber({
    required BuildContext context,
    required String title,
    required String description,
    required int begin,
    required int end,
    required int jump,
    required int initial,
    required int number,
  }) {
    BuildContext? dialogContext;
    Picker(
      adapter: NumberPickerAdapter(data: [
        NumberPickerColumn(
          begin: begin, 
          end: end, 
          jump: jump, 
          initValue: initial,
        ),
      ]),
      textStyle: AppStyle.bodyText(),
      itemExtent: 40.0,
      cancel: const SizedBox(),
      confirmText: "Save",
      backgroundColor: AppStyle.surfaceColor,
      confirmTextStyle: const TextStyle(color: AppStyle.primaryColor),
      hideHeader: true,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppStyle.heading3()),
                const SizedBox(height: 4.0),
                Text(description, style: AppStyle.caption1()),
              ],
            ),
          ),
          const SizedBox(width: 8.0),
          GestureDetector(
            onTap: () => Navigator.pop<void>(dialogContext!),
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
      onConfirm: (Picker picker, List value) {
        final value = picker.getSelectedValues().first as int;
        if(number == 0) {
          context.read<GoalSettingsCubit>().setDailyGoalDetails(steps: value);
        }
        if(number == 1) {
          context.read<GoalSettingsCubit>().setDailyGoalDetails(minutes: value);
        }
        if(number == 2) {
          context.read<GoalSettingsCubit>().setDailyGoalDetails(calories: value);
        }
      }
    ).showDialog(
      context, 
      backgroundColor: AppStyle.surfaceColor, 
      surfaceTintColor: AppStyle.surfaceColor,
      builder: (context, pickerWidget) {
        dialogContext = context;
        return pickerWidget;
      },
    );
  }
}