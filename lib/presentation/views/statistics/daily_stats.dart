import 'dart:async';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../core/services/report_service.dart';
import '../../../core/utilities/constants.dart';
import '../../../core/utilities/utils.dart';
import '../../../domain/entities/chart_data.dart';
import '../../../domain/entities/daily_steps.dart';
import '../../../domain/entities/report.dart';
import '../../../domain/entities/user.dart';
import '../../widgets/appBar.dart';
import '../../widgets/text.dart';
import 'trends.dart';

class DailyStats extends StatefulWidget {
  const DailyStats({super.key});

  @override
  State<StatefulWidget> createState() => _DailyStatsState();
}

class _DailyStatsState extends State<DailyStats> {
  int current = 0;
  String current_date = MyUtils.getCurrentDateAsSqlFormat();
  User? u;
  int currentSort = 1;
  Timer? _timer;

  List<DailySummary> weeklySummary = [DailySummary.empty()];

  @override
  initState() {
    super.initState();
    fetchWeeklyRecords();
    _timer = Timer.periodic(const Duration(minutes: 5), (timer) async {
      print('Refreshing quarter report');
      ReportService.instance.summarizeData(MyUtils.getCurrentDateAsSqlFormat());
      fetchWeeklyRecords();
    });
  }

  Future<List<DailySummary>> fetchWeeklyRecords() async {
    print('Fetched Weekly Records');
    List<DailySummary> res =
        await ReportService.instance.fetchWeeklyReport(current_date);
    setState(() {
      weeklySummary = res;
      current = 6;
    });
    return res;
  }

  Future<List<Report>> fetchHourlyReport(String date) async {
    return await ReportService.instance.fetchHourlyReport(date);
  }

  Widget get weeklyComparisionChart {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 200,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextTypes.heading_2(content: 'Trends'),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextTypes.paragraph(
                          content:
                              'Want to know more about your runs and metrics, explore here!'),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Constants.primaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Trends()));
                        },
                        child: const Text('See More')),
                  ]),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.insights,
              size: 55,
            ),
          )
        ],
      ),
    );
  }

  Widget stepsGraphByHour(String date) {
    return FutureBuilder(
        future: fetchHourlyReport(date),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            List<ChartData> chartData =
                snapshot.data!.map((e) => ChartData.hourlyData(e)).toList();
            return SfCartesianChart(
                margin: const EdgeInsets.all(0),
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                    minimum: 0,
                    maximum: 24,
                    majorTickLines: const MajorTickLines(color: Colors.white),
                    tickPosition: TickPosition.inside,
                    axisLine: const AxisLine(color: Colors.white),
                    majorGridLines: const MajorGridLines(width: 0),
                    labelStyle: const TextStyle(color: Colors.white)),
                primaryYAxis: CategoryAxis(
                    isVisible: false,
                    minimum: 0,
                    maximum: MyUtils.getMaxValue(chartData)),
                series: <ChartSeries<ChartData, int>>[
                  ColumnSeries<ChartData, int>(
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      width: 1,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: Colors.white,
                      spacing: 0.1)
                ]);
          } else {
            return const Center(
              child: Text(""),
            );
          }
        }));
  }

  Widget reportWidget(DailySummary record) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Container(
            color: Constants.primaryColor,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 15, 25, 25),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextTypes.heading_1(
                        content: record.steps.toString(),
                        fontSize: 48,
                        color: Colors.white),
                    TextTypes.paragraph(
                        content: 'steps',
                        fontSize: 24,
                        height: 0.8,
                        color: Colors.white),
                    SizedBox(height: 140, child: stepsGraphByHour(record.date)),
                  ]),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 15, 25, 5),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextTypes.heading_2(content: "Distance"),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    TextTypes.heading_1(
                        content: record.distance.toStringAsFixed(1)),
                    const Text(" km"),
                  ],
                ),
              ]),
        ),
        const Divider(color: Constants.primaryColor),
        Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 5, 25, 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextTypes.heading_2(content: "Calories"),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  TextTypes.heading_1(content: record.calories.toString()),
                  const Text(" kcal"),
                ],
              ),
            ],
          ),
        ),
        const Divider(color: Constants.primaryColor),
        Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 5, 25, 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextTypes.heading_2(content: "Stairs Climbed"),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  TextTypes.heading_1(content: record.stair.toString()),
                  const Text(" stairs"),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> get dailyRow {
    List<Widget> row = [];
    for (int i = 7; i > 0; i--) {
      row.add(completePercentage(weeklySummary[i], i));
    }
    return row;
  }

  List<ChartData> getCircularData(int steps, int position) {
    return <ChartData>[
      ChartData(0, ((5000 - steps) / 5000 * 100).round(),
          position == current ? Colors.white : Colors.grey),
      ChartData(
          1,
          ((steps) / 5000 * 100).round(),
          position == current
              ? Constants.primaryColor
              : Constants.paragraphColor)
    ];
  }

  Widget completePercentage(DailySummary record, int position) {
    return GestureDetector(
      onDoubleTap: () {
        fetchWeeklyRecords();
      },
      onTap: () {
        ReportService.instance.summarizeData(record.date);
        setState(() {
          current = position;
        });
      },
      child: Column(
        children: [
          position != current
              ? SizedBox(
                  width: 40,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Column(
                      children: [
                        Text(MyUtils.getDateFirstLetter(record.date)),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            record.date.split('/')[2],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Constants.primaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          MyUtils.getDateFirstLetter(record.date),
                          style: const TextStyle(color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            record.date.split('/')[2],
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  List<Widget> get progresRow {
    List<Widget> res = [];
    int i = 0;
    if (weeklySummary.isNotEmpty) {
      for (DailySummary daily in weeklySummary) {
        res.add(completePercentage(daily, i));
        i++;
      }
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawerEnableOpenDragGesture: false,
      appBar: CustomAppBar.get(
          title: "Summary",
          actions: [
            IconButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                      builder: ((context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Constants
                                  .primaryColor, // header background color // body text color
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                                foregroundColor:
                                    Colors.black, // button text color
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      }));
                  if (pickedDate != null) {
                    String formattedDate =
                        MyUtils.getFormattedDate(pickedDate);
                    setState(() {
                      current_date = formattedDate;
                    });
                    fetchWeeklyRecords();
                  }
                },
                icon: const Icon(Icons.date_range))
          ],
          leading: IconButton(
              onPressed: () {
                showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(65.0))),
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return const SizedBox();
                      // return const UserDetails();
                    });
              },
              icon: const Icon(Icons.supervised_user_circle))),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          // Swiping in right direction.
          if (details.primaryVelocity! < 0) {
            if (current < weeklySummary.length - 1) {
              setState(() {
                current++;
              });
            }
          }

          // Swiping in left direction.
          if (details.primaryVelocity! > 0) {
            if (current > 0) {
              setState(() {
                current--;
              });
            }
          }
        },
        child: SingleChildScrollView(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              weeklySummary.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: progresRow,
                          ),
                        ),
                        reportWidget(weeklySummary[current]),
                        const Divider(color: Constants.primaryColor),
                        weeklyComparisionChart,
                      ],
                    )
                  : reportWidget(DailySummary.empty())
            ],
          ),
        )),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
