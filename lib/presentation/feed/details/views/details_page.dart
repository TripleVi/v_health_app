import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:syncfusion_flutter_charts/charts.dart";

import "../../../../core/resources/style.dart";
import "../../../../core/utilities/utils.dart";
import "../../../../domain/entities/post.dart";
import "../../../site/bloc/site_bloc.dart";
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

  Widget _mainContent(BuildContext context, DetailsLoaded state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          summaryWidget(context, state),
          const SizedBox(height: 12.0),
          _mapSection(context, state),
          const SizedBox(height: 12.0),
          chartsWidget(context, state),
        ],
      ),
    );
  }

  Widget _mapSection(BuildContext context, DetailsLoaded state) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppStyle.surfaceColor,
        borderRadius: BorderRadius.circular(AppStyle.borderRadius),
      ),
      constraints: const BoxConstraints(minHeight: 200.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Route taken", style: AppStyle.heading4()),
          const SizedBox(height: 12.0),
          GestureDetector(
            onTap: () async {
              context.read<SiteBloc>().add(NavbarHidden());
              await Navigator.pushNamed<void>(
                context, "/mapPage", 
                arguments: state.post,
              );
              await Future.delayed(const Duration(milliseconds: 500))
                  .then((_) => context.read<SiteBloc>().add(NavbarShown()));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppStyle.borderRadius),
              child: CachedNetworkImage(
                imageUrl: state.post.mapUrl,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
                progressIndicatorBuilder: (context, url, download) => Container(
                  color: AppStyle.backgroundColor,
                  child: Center(child: CircularProgressIndicator(
                      value: download.progress)),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        ],
      )
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
          Text("Workout details", style: AppStyle.heading4()),
          const SizedBox(height: 12.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _metricsWidget(
                      name: "Active time",
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
                      name: "Avg. speed",
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
                      name: "Max. speed",
                      value: maxSMap["value"]!,
                      unit: maxSMap["unit"],
                    ),
                    const SizedBox(height: 8.0),
                    _metricsWidget(
                      name: "Avg. pace",
                      value: avgPMap["value"]!,
                      unit: avgPMap["unit"],
                    ),
                    const SizedBox(height: 8.0),
                    _metricsWidget(
                      name: "Max. pace",
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

  Widget chartsWidget(BuildContext context, DetailsLoaded state) {
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
          workoutDataChart(
            title: "Speed",
            xDataSource: state.times,
            yDataSource: state.speeds,
            avgValue: state.avgSpeed,
            seriesColor: AppStyle.speedColor,
            unit: "m/s",
            toolTipValue: (data) => data.toStringAsFixed(1),
          ),
          const SizedBox(height: 16.0),
          workoutDataChart(
            title: "Pace",
            xDataSource: state.times,
            yDataSource: state.paces,
            avgValue: state.avgPace,
            seriesColor: AppStyle.paceColor,
            unit: "/m",
            toolTipValue: (data) => "${data.toStringAsFixed(1)}''",
          ),
        ],
      ),
    );
  }

  Widget workoutDataChart({
    required String title,
    required List<int> xDataSource,
    required List<double> yDataSource,
    required double avgValue,
    required Color seriesColor,
    required String unit,
    required String Function(double data) toolTipValue,
  }) {
    return SizedBox(
      height: 200.0,
      child: SfCartesianChart(
        backgroundColor: AppStyle.surfaceColor,
        title: ChartTitle(
          text: title,
          textStyle: AppStyle.heading5(),
          alignment: ChartAlignment.near,
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          color: AppStyle.backgroundColor,
          borderWidth: 0.0,
          opacity: 0.9,
          builder: (data, point, series, pointIndex, seriesIndex) {
            final value = toolTipValue(point.y! * 1.0);
            return Container(
              padding: const EdgeInsets.all(4.0),
              color: AppStyle.backgroundColor,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    MyUtils.getFormattedMinutes(data),
                    style: AppStyle.caption2(color: AppStyle.primaryTextColor),
                  ),
                  const SizedBox(width: 4.0),
                  Container(
                    width: 4.0,
                    height: 4.0,
                    decoration: const BoxDecoration(
                      color: AppStyle.secondaryTextColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    "$value $unit", 
                    style: AppStyle.caption1(color: series.color!),
                  ),
                ],
              ),
            );
          },
        ),
        margin: const EdgeInsets.all(0.0),
        plotAreaBorderWidth: 0.0,
        primaryXAxis: NumericAxis(
          desiredIntervals: 4,
          majorTickLines: const MajorTickLines(
              color: AppStyle.secondaryTextColor),
          axisLine: const AxisLine(color: AppStyle.secondaryTextColor),
          majorGridLines: const MajorGridLines(width: 0.0),
          labelStyle: AppStyle.caption2(),
          axisLabelFormatter: (labelArgs) {
            if(labelArgs.value == 0) {
              return ChartAxisLabel("0", labelArgs.textStyle);
            }
            final txt = MyUtils.getFormattedMinutes(int.parse(labelArgs.text));
            return ChartAxisLabel(txt, labelArgs.textStyle);
          },
        ),
        primaryYAxis: NumericAxis(
          opposedPosition: true,
          decimalPlaces: 0,
          minimum: 0.0,
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
        series: <CartesianSeries<int, int>>[
          SplineSeries(
            dataSource: xDataSource,
            xValueMapper: (data, _) => data,
            yValueMapper: (data, index) => yDataSource[index],
            color: seriesColor,
          ),
          LineSeries(
            enableTooltip: false,
            color: AppStyle.primaryColor,
            dataSource: [0, xDataSource.last],
            xValueMapper: (data, _) => data,
            yValueMapper: (data, _) => avgValue,
            dashArray: const [3.0],
            dataLabelMapper: (datum, index) {
              return index == 0 ? null : avgValue.toStringAsFixed(1);
            },
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              margin: const EdgeInsets.all(0.0),
              textStyle: AppStyle.caption2(color: AppStyle.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
