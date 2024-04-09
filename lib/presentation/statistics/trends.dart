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

class Trends extends StatefulWidget {
  const Trends({super.key});

  @override
  State<StatefulWidget> createState() => _TrendsState();
}

class _TrendsState extends State<Trends> {
  int currentSort = 1;
  List<DailyReport> records = [DailyReport.empty()];

  List<ChartData> today = [];
  List<ChartData> yesterday = [];

  bool isLoading = false;
  bool isFetched = false;

  String percentage = "0";
  var chartData = <ChartData>[];
  var median = 0;

  Map<int, int> sortTypes = {
    1: 7,
    2: 30,
    3: 182,
    4: 365,
  };

  @override
  void initState() {
    super.initState();
    fetchRecords();
    fetchDailyComparision();
  }

  void fetchDailyComparision() async {
    final dRepo = DailyReportRepo();
    final dReport = await dRepo.fetchDailyReport(DateTime.now());
    final hRepo = HourlyReportRepo();
    final date = MyUtils.getDateFromSqlFormat(MyUtils.get_date_subtracted_by_i(
            MyUtils.getDateAsSqlFormat(DateTime.now()), 1));
    final temp = await dRepo.fetchDailyReport(date);
    var t = await hRepo
        .fetchReportsByDate(dReport.id);
    var y = await hRepo.fetchReportsByDate(temp.id);

    int index = 0;
    int sum = 0;
    List<ChartData> t1 = [];
    for (var tData in t) {
      sum += tData.calories;
      t1.add(ChartData(index, sum, Colors.black));
      index++;
    }

    index = 0;
    sum = 0;
    List<ChartData> y1 = [];
    for (var yData in y) {
      sum += yData.calories;
      y1.add(ChartData(index, sum, Colors.black));
      index++;
    }

    setState(() {
      today = t1;
      yesterday = y1;
    });
  }

  void fetchRecords() async {
    final dRepo = DailyReportRepo();
    List<DailyReport> res = await dRepo.fetchRecentReports(
        DateTime.now(), sortTypes[currentSort]!);

    var data = <ChartData>[];
    int index = 1;
    for (var d in res) {
      data.add(ChartData.dailyReport(index, d));
      index++;
    }

    setState(() {
      chartData = data;
      isLoading = false;
      median = int.parse(medianSteps);
      isFetched = true;
    });
    print(res.length);
  }

  Future<List<Report>> fetchDailyReport(String date) async {
    final dRepo = DailyReportRepo();
    final hRepo = HourlyReportRepo();
    final dReport = await dRepo.fetchDailyReport(MyUtils.getDateFromSqlFormat(date));
    return await hRepo.fetchReportsByDate(dReport.id);
  }

  double get difference {
    int time = DateTime.now().hour;
    double difference = 0;
    if (today.length >= 24 && yesterday.length >= 24) {
      int t_cal = today[time].y;
      int y_cal = yesterday[time].y;
      print("$t_cal   -  $y_cal - ${DateTime.now().hour}");
      if (y_cal != 0) {
        difference = (t_cal - y_cal) / y_cal * 100;
      }
    }
    return difference;
  }

  Widget get summary {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text.rich(TextSpan(
          style: const TextStyle(
            fontFamily: Constants.fontFace,
            fontSize: Constants.paragraph_size,
            color: Constants.paragraphColor,
            height: Constants.line_height,
            letterSpacing: Constants.letter_spacing,
            fontWeight: FontWeight.w300,
          ),
          children: [
            const TextSpan(
                text: "Comparing to yesterday, at this hour, you have burned "),
            TextSpan(
                text:
                    '${difference >= 0 ? '${difference.abs().toStringAsFixed(2)}% more' : '${difference.abs().toStringAsFixed(2)}% less'} ',
                style: const TextStyle(color: Constants.primaryColor)),
            const TextSpan(text: " calories "),
          ])),
    );
  }

  Widget sortButton(int index, String tag) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          backgroundColor:
              currentSort == index ? Constants.primaryColor : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        onPressed: () {
          setState(() {
            if (!isLoading) {
              currentSort = index;
              setState(() {
                isLoading = true;
              });
            }
          });
          fetchRecords();
        },
        child: Text(tag,
            style: currentSort == index
                ? const TextStyle(color: Colors.white)
                : const TextStyle(color: Constants.textColor)));
  }

  String get medianSteps {
    int sum = 0;
    for (var d in chartData) {
      sum += d.y;
    }
    return "${(sum / sortTypes[currentSort]!).round()}";
  }

  // String get currentDuration {
  //   return "${MyUtils.getFormattedDate(DateTime.parse(MyUtils.getCurrentDateAsSqlFormat()))} - ${MyUtils.getFormattedDate(DateTime.parse(MyUtils.get_date_subtracted_by_i(MyUtils.getCurrentDateAsSqlFormat(), sortTypes[currentSort]!)))}";
  // }

  String get currentDuration {
    return "${MyUtils.getDateAsSqlFormat(DateTime.now())} - ${MyUtils.get_date_subtracted_by_i(MyUtils.getDateAsSqlFormat(DateTime.now()), sortTypes[currentSort]!)}";
  }

  Widget get stepsComparison {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextTypes.paragraph(content: 'Average steps'),
                TextTypes.heading_1(
                    content: medianSteps, color: Constants.primaryColor),
                TextTypes.paragraph(content: currentDuration)
              ],
            ),
          ],
        ),
        // Padding(
        //   padding: const EdgeInsets.only(top: 10),
        //   child: SizedBox(
        //     height: 200,
        //     child: SfCartesianChart(
        //         primaryXAxis: NumericAxis(
        //           tickPosition: TickPosition.inside,
        //         ),
        //         primaryYAxis: CategoryAxis(
        //             majorGridLines: const MajorGridLines(width: 0),
        //             minimum: MyUtils.getMinValue(chartData),
        //             maximum: MyUtils.getMaxValue(chartData)),
        //         series: <ChartSeries>[
        //           // Renders line chart
        //           LineSeries<ChartData, int>(
        //               color: Constants.paragraphColor,
        //               dataSource: chartData,
        //               xValueMapper: (ChartData data, _) => data.x,
        //               yValueMapper: (ChartData data, _) => median),
        //           SplineSeries<ChartData, int>(
        //             color: Constants.primaryColor,
        //             dataSource: chartData,
        //             xValueMapper: (ChartData data, _) => data.x,
        //             yValueMapper: (ChartData data, _) => data.y,
        //           )
        //         ]),
        //   ),
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            sortButton(1, 'W'),
            sortButton(2, 'M'),
            sortButton(3, '6M'),
            sortButton(4, 'Y'),
          ],
        ),
      ],
    );
  }

  Widget get caloriesComparison {
    int time = DateTime.now().hour;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      summary,
      // Padding(
      //   padding: const EdgeInsets.only(top: 10),
      //   child: SizedBox(
      //     height: 200,
      //     child: SfCartesianChart(
      //         borderWidth: 0,
      //         primaryXAxis: NumericAxis(
      //           majorTickLines: const MajorTickLines(
      //               size: 6, width: 2, color: Constants.paragraphColor),
      //           minorTickLines: const MinorTickLines(
      //               size: 4, width: 2, color: Constants.paragraphColor),
      //           minorTicksPerInterval: 2,
      //           plotBands: <PlotBand>[
      //             PlotBand(
      //               color: const Color.fromARGB(255, 132, 132, 132),
      //               start: time,
      //               end: time + 0.1,
      //               isVisible: true,
      //             )
      //           ],
      //           tickPosition: TickPosition.inside,
      //         ),
      //         primaryYAxis: CategoryAxis(
      //             isVisible: false,
      //             minimum: 0,
      //             maximum: MyUtils.getMaxValue(yesterday)),
      //         series: <ChartSeries>[
      //           // Renders line chart
      //           SplineSeries<ChartData, int>(
      //               color: Constants.paragraphColor,
      //               dataSource: yesterday,
      //               xValueMapper: (ChartData data, _) => data.x,
      //               yValueMapper: (ChartData data, _) => data.y),
      //           SplineSeries<ChartData, int>(
      //             color: Constants.primaryColor,
      //             dataSource: today,
      //             xValueMapper: (ChartData data, _) => data.x,
      //             yValueMapper: (ChartData data, _) => data.y,
      //           ),
      //         ]),
      //   ),
      // ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.get(
          title: "Trends",
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 12.0),
                child: Icon(Icons.arrow_back_rounded),
              ),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: TextTypes.heading_1(content: "Steps", fontSize: 28),
              ),
              stepsComparison,
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 25, 0, 5),
                child: TextTypes.heading_1(content: "Calories", fontSize: 28),
              ),
              caloriesComparison
            ],
          ),
        ),
      ),
    );
  }
}
