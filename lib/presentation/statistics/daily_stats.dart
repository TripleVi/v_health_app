import 'dart:async';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../data/repositories/daily_report_repo.dart';
import '../../core/utilities/constants.dart';
import '../../core/utilities/utils.dart';
import '../../data/repositories/hourly_report_repo.dart';
import '../../domain/entities/chart_data.dart';
import '../../domain/entities/daily_report.dart';
import '../../domain/entities/report.dart';
import '../widgets/app_bar.dart';
import '../widgets/text.dart';
import 'trends.dart';

class DailyStats extends StatefulWidget {
  const DailyStats({super.key});

  @override
  State<StatefulWidget> createState() => _DailyStatsState();
}

class _DailyStatsState extends State<DailyStats> {
  int current = 0;
  String currentDate = MyUtils.getDateAsSqlFormat(DateTime.now());
  Timer? _timer;

  List<DailyReport> weeklySummary = [DailyReport.empty()];

  @override
  initState() {
    print("init state");
    super.initState();
    fetchWeeklyRecords();
    // _timer = Timer.periodic(const Duration(seconds: 15), (_) async {
    //   await fetchWeeklyRecords();
    // });
  }

  Future<List<DailyReport>> fetchWeeklyRecords() async {
    print('Fetched Weekly Records');
    final repo = DailyReportRepo();
    final res = await repo.fetchWeeklyReport(currentDate);
    setState(() {
      weeklySummary = res;
      current = 6;
    });
    return res;
  }

  Future<List<Report>> fetchDailyReport(DateTime date) async {
    final dRepo = DailyReportRepo();
    final dReport = await dRepo.fetchDailyReport(date);
    final hRepo = HourlyReportRepo();
    return await hRepo.fetchReportsByDate(dReport.id);
  }

  Widget get weeklyComparisonChart {
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

  Widget stepsGraphByHour(DateTime date) {
    return FutureBuilder(
      future: fetchDailyReport(date),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          List<ChartData> chartData =
              snapshot.data!.map((e) => ChartData.hourlyData(e)).toList();
          return SfCartesianChart(
              margin: const EdgeInsets.all(0),
              plotAreaBorderWidth: 0,
              primaryXAxis: const CategoryAxis(
                  minimum: 0,
                  maximum: 24,
                  majorTickLines: MajorTickLines(color: Colors.white),
                  tickPosition: TickPosition.inside,
                  axisLine: AxisLine(color: Colors.white),
                  majorGridLines: MajorGridLines(width: 0),
                  labelStyle: TextStyle(color: Colors.white)),
              primaryYAxis: CategoryAxis(
                  isVisible: false,
                  minimum: 0,
                  maximum: MyUtils.getMaxValue(chartData)),
              series: <CartesianSeries<ChartData, int>>[
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
      })
    );
  }

  Widget reportWidget(DailyReport record) {
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
                  TextTypes.heading_1(content: "20"),
                  const Text(" stairs"),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget completePercentage(DailyReport report, int position) {
    final txtDate = MyUtils.getDateAsSqlFormat(report.date);
    return GestureDetector(
      onDoubleTap: () {
        fetchWeeklyRecords();
      },
      onTap: () {
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
                        Text(MyUtils.getDateThreeLetters(report.date)),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            txtDate.split('/')[2],
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
                          MyUtils.getDateThreeLetters(report.date),
                          style: const TextStyle(color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            txtDate.split('/')[2],
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

  List<Widget> get progressRow {
    List<Widget> res = [];
    int i = 0;
    if (weeklySummary.isNotEmpty) {
      for (DailyReport daily in weeklySummary) {
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
                  })
                );
                if (pickedDate != null) {
                  String formattedDate =
                      MyUtils.getFormattedDate1(pickedDate);
                  setState(() {
                    currentDate = formattedDate;
                  });
                  fetchWeeklyRecords();
                }
              },
              icon: const Icon(Icons.date_range),
            )
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
                            children: progressRow,
                          ),
                        ),
                        reportWidget(weeklySummary[current]),
                        const Divider(color: Constants.primaryColor),
                        weeklyComparisonChart,
                      ],
                    )
                  : reportWidget(DailyReport.empty())
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
