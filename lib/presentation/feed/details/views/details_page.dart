import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:syncfusion_flutter_charts/charts.dart";

import "../../../../core/resources/style.dart";
import "../../../../core/utilities/utils.dart";
import "../../../../domain/entities/post.dart";
import "../../../../domain/entities/workout_data.dart";
import "../../../widgets/app_bar.dart";
import "../../../widgets/loading_indicator.dart";
import "../cubit/details_cubit.dart";

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final post = ModalRoute.of(context)!.settings.arguments as Post;
    return BlocProvider(
      create: (context) => DetailsCubit(post),
      child: const DetailsView(),
    );
  }
}

class DetailsView extends StatelessWidget {
  const DetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      appBar: CustomAppBar.get(title: "Details"),
      body: Center(
        child: Container(
          height: double.infinity,
          constraints: const BoxConstraints(maxWidth: 520.0),
          padding: const EdgeInsets.all(12.0),
          child: BlocBuilder<DetailsCubit, DetailsState>(
            builder: (context, state) {
              if(state is DetailsLoading) {
                return const AppLoadingIndicator();
              }
              if(state is DetailsLoaded) {
                return _mainContent(context, state);
              }
              if(state is DetailsError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.warning_rounded, 
                        size: 68.0, 
                        color: AppStyle.primaryColor,
                      ),
                      Text("Oops, something went wrong!", style: AppStyle.caption1()),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  // Widget _mapSection(BuildContext context, DetailsLoaded state) {
  //   return GestureDetector(
  //     onTap: () async {
  //       context.read<SiteBloc>().add(NavbarHidden());
  //       await Navigator.pushNamed<void>(
  //         context, "/mapPage", 
  //         arguments: state.post,
  //       );
  //       await Future.delayed(const Duration(milliseconds: 500))
  //           .then((_) => context.read<SiteBloc>().add(NavbarShown()));
  //     },
  //     child: AspectRatio(
  //       aspectRatio: 2 / 1,
  //       child: Image.network(
  //         // state.post.mapUrl,
  //         "https://static.vecteezy.com/system/resources/thumbnails/026/829/465/small/beautiful-girl-with-autumn-leaves-photo.jpg",
  //         // loadingBuilder: (context, child, loadingProgress) {
  //         //   return const AppLoadingIndicator();
  //         // },
  //         filterQuality: FilterQuality.high,
  //         fit: BoxFit.contain,
  //         isAntiAlias: true,
  //       ),
  //     ),
  //   );
  // }

  Widget _mainContent(BuildContext context, DetailsLoaded state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          summaryWidget(context, state),
          // _mapSection(context, state),
          const SizedBox(height: 12.0),
          chartWidget(context, state),
          const SizedBox(height: 12.0),
        ],
      ),
    );
  }

  Widget summaryWidget(BuildContext context, DetailsLoaded state) {
    final record = state.post.record;
    final time = MyUtils.getFormattedDuration(record.activeTime);
    final distanceMap = MyUtils.getFormattedDistance(record.distance);
    final avgSMap = MyUtils.getFormattedSpeed(record.avgSpeed);
    final maxSMap = MyUtils.getFormattedSpeed(record.maxSpeed);
    final avgPMap = MyUtils.getFormattedPace(record.avgSpeed);
    final maxPMap = MyUtils.getFormattedPace(record.maxSpeed);
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppStyle.surfaceColor,
        borderRadius: BorderRadius.circular(AppStyle.borderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Workout details", style: AppStyle.heading5()),
          const SizedBox(height: 16.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _metricsWidget(
                      name: "Workout duration",
                      value: time,
                    ),
                    const SizedBox(height: 8.0),
                    _metricsWidget(
                      name: "Distance",
                      value: distanceMap["value"]!,
                      unit: distanceMap["unit"],
                    ),
                    const SizedBox(height: 8.0),
                    _metricsWidget(
                      name: "Steps",
                      value: "${record.steps}",
                    ),
                    const SizedBox(height: 8.0),
                    _metricsWidget(
                      name: "Avg speed",
                      value: avgSMap["value"]!,
                      unit: avgSMap["unit"],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4.0),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _metricsWidget(
                      name: "Max speed",
                      value: maxSMap["value"]!,
                      unit: maxSMap["unit"],
                    ),
                    const SizedBox(height: 8.0),
                    _metricsWidget(
                      name: "Avg pace",
                      value: avgPMap["value"]!,
                      unit: avgPMap["unit"],
                    ),
                    const SizedBox(height: 8.0),
                    _metricsWidget(
                      name: "Max pace",
                      value: maxPMap["value"]!,
                      unit: maxPMap["unit"],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricsWidget({
    required String name,
    required String value,
    String? unit,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: AppStyle.caption1()),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("$value ", style: AppStyle.heading4()),
            Text(unit ?? "", style: AppStyle.heading5()),
          ],
        ),
      ],
    );
  }

  Widget chartWidget(BuildContext context, DetailsLoaded state) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppStyle.surfaceColor,
        borderRadius: BorderRadius.circular(AppStyle.borderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text("Workout details", style: AppStyle.heading5()),
          // const SizedBox(height: 16.0),
          workoutDataChart(state)
        ],
      ),
    );
  }

  Widget workoutDataChart(DetailsLoaded state) {
    print(state.post.record.data);
    return SizedBox(
      height: 200.0,
      child: SfCartesianChart(
        backgroundColor: AppStyle.surfaceColor,
        title: ChartTitle(
          text: "Workout data", 
          textStyle: AppStyle.heading5(),
          alignment: ChartAlignment.near,
        ),
        margin: const EdgeInsets.all(0.0),
        plotAreaBorderWidth: 0.0,
        primaryXAxis: CategoryAxis(
          // interval: interval,
          majorTickLines: const MajorTickLines(
            color: AppStyle.secondaryTextColor,
          ),
          axisLine: const AxisLine(color: AppStyle.secondaryTextColor),
          majorGridLines: const MajorGridLines(width: 0.0),
          labelStyle: AppStyle.caption2(),
          // axisLabelFormatter: xAxisLabelText == null 
          //     ? null 
          //     : (labelArgs) {
          //       final txt = xAxisLabelText(labelArgs.value.toInt());
          //       return ChartAxisLabel(txt, labelArgs.textStyle);
          //     },
        ),
        primaryYAxis: NumericAxis(
          opposedPosition: true,
          decimalPlaces: 0,
          minimum: 0.0,
          // maximum: maxYAxis*1.0,
          // desiredIntervals: 2,
          majorTickLines: const MajorTickLines(width: 0.0, size: 0.0),
          axisLine: const AxisLine(width: 0.0),
          labelStyle: AppStyle.caption2(),
          axisLabelFormatter: (labelArgs) {
            return ChartAxisLabel(
              MyUtils.getCompactNumberFormat(labelArgs.value), 
              labelArgs.textStyle,
            );
          },
        ),
        series: <CartesianSeries<WorkoutData, int>>[
          SplineSeries(
            dataSource: state.post.record.data,
            xValueMapper: (data, index) => data.time,
            yValueMapper: (data, _) => data.steps,
            color: AppStyle.stepColor,

            // markerSettings: MarkerSettings(
            // isVisible: true,
            // height: 4,
            // width: 4,
            // shape: DataMarkerType.circle,
            // borderWidth: 3,
            // borderColor: Colors.black),
        // dataLabelSettings: DataLabelSettings(
        //     isVisible: true,
        //     labelAlignment: ChartDataLabelAlignment.auto)
          ),
        ],
      ),
    );
  }
}
