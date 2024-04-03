import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/statistics_cubit.dart';

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
    return const Placeholder();
  }
}