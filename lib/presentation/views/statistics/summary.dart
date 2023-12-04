import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../core/utilities/utils.dart';
import '../../../domain/entities/activity_record.dart';
import '../../../domain/entities/chart_data.dart';
import '../../widgets/bordered_card.dart';
import '../../widgets/text.dart';

class DailySummary extends StatefulWidget {
  const DailySummary({super.key});

  @override
  State<StatefulWidget> createState() => _DailySummaryState();
}

class _DailySummaryState extends State<DailySummary> {
  int progress = 0;

  ActivityRecord record = ActivityRecord.empty();

  Future<ActivityRecord> getSummary() async {
    return ActivityRecord.empty();
  }

  List<ChartData> hourlyStepsLine() {
    return [];
  }

  void shareSummary() {}

  Widget summaryCard(String title, Icon icon, Widget content) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 5),
      child: BorderedCard(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Column(children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [TextTypes.heading_2(content: title), icon],
          ),
          content
        ]),
      )),
    );
  }

  Widget get summary => Column(
        children: [
          SfCartesianChart(
              // Columns will be rendered back to back
              enableSideBySideSeriesPlacement: false,
              series: <ChartSeries<ChartData, int>>[
                ColumnSeries<ChartData, int>(
                    dataSource: hourlyStepsLine(),
                    xValueMapper: (ChartData data, _) => data.x.round(),
                    yValueMapper: (ChartData data, _) => data.y),
              ]),
          summaryCard(
              "Total workout time",
              const Icon(Icons.timelapse),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  TextTypes.heading_1(
                      content: "${MyUtils.getHours(record.workoutDuration)}"),
                  const Text(" hours "),
                  TextTypes.heading_1(
                      content:
                          "${MyUtils.getMinutes(record.workoutDuration)}"),
                  const Text(" minutes ")
                ],
              )),
          summaryCard(
              "Distance travelled",
              const Icon(Icons.timelapse),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  TextTypes.heading_1(content: "${record.distance}"),
                  const Text(" km "),
                ],
              )),
          summaryCard(
              "Climbed Stairs",
              const Icon(Icons.stairs),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  TextTypes.heading_1(content: "${record.stairsClimbed}"),
                  const Text(" stairs "),
                ],
              )),
          summaryCard(
              "Calories burnt",
              const Icon(Icons.timelapse),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  TextTypes.heading_1(content: "${record.calories}"),
                  const Text(" kcal "),
                ],
              )),
        ],
      );

  Widget get comparision => BorderedCard(
          child: Column(
        children: const [],
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: FutureBuilder<ActivityRecord>(
        future: getSummary(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        TextTypes.paragraph(content: "Today's summary"),
                        Text(MyUtils.getFormattedDate(DateTime.now())),
                      ],
                    ),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.arrow_back))
                  ],
                ),
                Row(
                  children: [
                    TextTypes.paragraph(content: "Total"),
                  ],
                ),
                summary,
                Row(
                  children: [
                    TextTypes.paragraph(content: "Comparision"),
                  ],
                ),
                comparision,
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      )),
    );
  }
}
