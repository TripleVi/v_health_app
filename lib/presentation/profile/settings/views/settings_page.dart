import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../../core/resources/style.dart";
import "../../../widgets/app_bar.dart";
import "../cubit/settings_cubit.dart";

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsCubit>(
      create: (context) => SettingsCubit(),
      child: const SettingsView(),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.get(title: "Settings"),
      backgroundColor: AppStyle.backgroundColor,
      body: Container(
        height: double.infinity,
        constraints: const BoxConstraints(maxWidth: 520.0),
        padding: const EdgeInsets.all(12.0),
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: AppStyle.surfaceColor,
                    borderRadius: BorderRadius.circular(AppStyle.borderRadius),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        onTap: () {
                          context.read<SettingsCubit>().logout();
                          Navigator.of(context, rootNavigator: true)
                              .pushNamedAndRemoveUntil<void>("/auth", (route) => false);
                        },
                        iconColor: AppStyle.secondaryIconColor,
                        textColor: Colors.red.shade400,
                        titleTextStyle: AppStyle.heading5(),
                        leading: const Icon(Icons.logout_rounded, size: 24.0),
                        title: const Text("Log out"),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}