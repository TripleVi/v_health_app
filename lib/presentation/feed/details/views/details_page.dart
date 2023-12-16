import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../core/resources/colors.dart';
import '../../../../core/resources/style.dart';
import '../../../../core/utilities/utils.dart';
import '../../../../domain/entities/post.dart';
import '../../../../domain/entities/workout_data.dart';
import '../../../site/bloc/site_bloc.dart';
import '../../../widgets/appBar.dart';
import '../../../widgets/loading_indicator.dart';
import '../cubit/details_cubit.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final post = ModalRoute.of(context)!.settings.arguments as Post;
    return BlocProvider(
      create: (context) => DetailsCubit(post),
      child: DetailsView(),
    );
  }
}

class DetailsView extends StatelessWidget {
  final _tooltipBehavior = TooltipBehavior(enable: true);
  DetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: CustomAppBar.get(
        title: "Details",
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 24.0,
            color: AppColor.onBackgroundColor,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: AppColor.onBackgroundColor)),
        ),
        child: BlocBuilder<DetailsCubit, DetailsState>(
          builder: (context, state) {
            if(state is DetailsLoading) {
              return const AppLoadingIndicator();
            }
            if(state is DetailsLoaded) {
              return _mainContent(context, state);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildCell(String title, String content) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: AppStyle.paragraph(height: 1)),
        const SizedBox(height: 8.0),
        Text(content, style: AppStyle.heading_2(height: 1)),
      ],
    );
  }

  Widget _mapSection(BuildContext context, DetailsLoaded state) {
    return GestureDetector(
      onTap: () async {
        context.read<SiteBloc>().add(NavbarHidden());
        await Navigator.pushNamed<void>(
          context, "/mapPage", 
          arguments: state.post,
        );
        await Future.delayed(const Duration(milliseconds: 500))
            .then((_) => context.read<SiteBloc>().add(NavbarShown()));
      },
      child: AspectRatio(
        aspectRatio: 2 / 1,
        child: Image.network(
          state.post.mapUrl,
          // loadingBuilder: (context, child, loadingProgress) {
          //   return const AppLoadingIndicator();
          // },
          filterQuality: FilterQuality.high,
          fit: BoxFit.contain,
          isAntiAlias: true,
        ),
      ),
    );
  }

  Widget _mainContent(BuildContext context, DetailsLoaded state) {
    final record = state.post.record;
    final data = record.data;
    final distanceMap = MyUtils.getFormattedDistance(record.distance);
    final avgSMap = MyUtils.getFormattedDistance(record.avgSpeed);
    final avgPMap = MyUtils.getFormattedDistance(record.avgPace);
    final maxSMap = MyUtils.getFormattedDistance(record.maxSpeed);
    final maxPMap = MyUtils.getFormattedDistance(record.maxPace);
    return SingleChildScrollView(
      child: Column(
        children: [
          // FutureBuilder(
          //   future: ImageUtils.getImageFile(record.mapName!),
          //   builder: (context, snapshot) {
          //     if(snapshot.hasData) {
          //       return GestureDetector(
          //         onTap: () {
                    
          //         },
          //         child: Image.file(
          //           snapshot.data!,
          //           width: double.infinity,
          //           height: 200.0,
          //           fit: BoxFit.cover,
          //         ),
          //       );
          //     }
          //     return Center(child: CircularProgressIndicator(
          //       color: AppColor.onBackgroundColor,
          //     ));
          //   }
          // ),
          const SizedBox(height: 40.0),
          _mapSection(context, state),
          Divider(
            height: 8.0,
            thickness: 8.0,
            color: AppColor.onBackgroundColor,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(
                isVisible: true,
                title: AxisTitle(text: "Time (mins)"),
              ),
              primaryYAxis: NumericAxis(
                isVisible: true,
                title: AxisTitle(text: "Speed (m/s)"),
              ),
              title: ChartTitle(text: "Speed - Time"),
              // legend: Legend(isVisible: true),
              tooltipBehavior: _tooltipBehavior,
              series: <LineSeries<WorkoutData, String>>[
                LineSeries<WorkoutData, String>(
                  color: AppColor.primaryColor,
                  dataSource:  data,
                  xValueMapper: (datum, index) => "${(datum.timeFrame/1000/60)}",
                  yValueMapper: (datum, index) => datum.speed,
                  // dataLabelSettings: const DataLabelSettings(isVisible: true)
                ),
              ],
            ),
          ),
          Divider(
            height: 8.0,
            thickness: 8.0,
            color: AppColor.onBackgroundColor,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Workout details", style: AppStyle.heading_2(height: 1)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildCell(
                          "Workout duration",
                          MyUtils.getFormattedDuration(record.workoutDuration),
                        ),
                      ),
                      VerticalDivider(
                        width: 2.0,
                        thickness: 2.0,
                        endIndent: 4.0,
                        color: AppColor.onBackgroundColor,
                      ),
                      Expanded(
                        child: _buildCell(
                          "Total duration",
                          MyUtils.getFormattedDuration(
                            record.endDate.difference(record.startDate).inSeconds
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildCell(
                        "Distance", 
                        "${distanceMap["value"]!} ${distanceMap["unit"]!}",
                      ),
                    ),
                    SizedBox(
                      height: 36.0,
                      child: VerticalDivider(
                        width: 2.0,
                        thickness: 2.0,
                        endIndent: 4.0,
                        color: AppColor.onBackgroundColor,
                      ),
                    ),
                    Expanded(
                      child: _buildCell(
                        "Elevation", 
                        "--",
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildCell(
                        "Workout calories", 
                        "${record.calories} cal",
                      ),
                    ),
                    SizedBox(
                      height: 36.0,
                      child: VerticalDivider(
                        width: 2.0,
                        thickness: 2.0,
                        endIndent: 4.0,
                        color: AppColor.onBackgroundColor,
                      ),
                    ),
                    Expanded(
                      child: _buildCell(
                        "Total calories", 
                        "${record.calories} cal",
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildCell(
                        "Avg. speed", 
                        "${avgSMap["value"]!} ${avgPMap["unit"]!}",
                      ),
                    ),
                    SizedBox(
                      height: 36.0,
                      child: VerticalDivider(
                        width: 2.0,
                        thickness: 2.0,
                        endIndent: 4.0,
                        color: AppColor.onBackgroundColor,
                      ),
                    ),
                    Expanded(
                      child: _buildCell(
                        "Max. speed", 
                        "${maxSMap["value"]!} ${maxSMap["unit"]!}",
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildCell(
                        "Avg. pace", 
                        "${avgPMap["value"]!} ${avgPMap["unit"]!}",
                      ),
                    ),
                    SizedBox(
                      height: 36.0,
                      child: VerticalDivider(
                        width: 2.0,
                        thickness: 2.0,
                        endIndent: 4.0,
                        color: AppColor.onBackgroundColor,
                      ),
                    ),
                    Expanded(
                      child: _buildCell(
                        "Max. pace", 
                        "${maxPMap["value"]!} ${maxPMap["unit"]!}",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
