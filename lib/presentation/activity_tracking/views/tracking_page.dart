import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/enum/activity_tracking.dart';
import '../../../core/resources/colors.dart';
import '../../../core/enum/metrics.dart';
import '../../../core/resources/style.dart';
import '../../camera/views/camera_page.dart';
import '../../site/bloc/site_bloc.dart';
import '../../widgets/appBar.dart';
import '../../widgets/dialog.dart';
import '../bloc/activity_tracking_bloc.dart';
import '../image_page.dart';
import '../saving/view/saving_page.dart';
import 'time_counter.dart';
import 'measurement_page.dart';

class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ActivityTrackingBloc>(
      create: (context) => ActivityTrackingBloc(),
      child: Navigator( 
        onGenerateRoute: (settings) {
          if(settings.name == "/tracking") {
            return MaterialPageRoute<void>(
              builder: (context) => TrackingView(),
              settings: settings,
            );
          }
          if(settings.name == "/saveForm") {
            return MaterialPageRoute<bool>(
              builder: (context) => const SavingPage(),
              settings: settings,
            );
          }
          if(settings.name == "/camera") {
            return MaterialPageRoute<PhotoParams>(
              builder: (context) => const CameraPage(),
              settings: settings,
            );
          }
          return null;
        },
        initialRoute: "/tracking",
      ),
    );
  }
}

class TrackingView extends StatelessWidget {
  final _txtDistanceWhole = TextEditingController(text: "1");
  final _txtDistanceFractional = TextEditingController(text: "0");
  final _txtDurationHour = TextEditingController(text: "01");
  final _txtDurationMinute = TextEditingController(text: "01");
  final _txtDurationSecond = TextEditingController(text: "01");
  final _txtCalories = TextEditingController(text: "01");
  final _visibilityChange = ValueNotifier(true);

  TrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: CustomAppBar.get(
        title: "Tracking",
        leading: _backBtn(context),
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColor.onBackgroundColor),
          ),
        ),
        child: BlocConsumer<ActivityTrackingBloc, TrackingState>(
          listener: (blocContext, state) {
            if (state.permissionParams != null) {
              MyDialog.showTwoOptionsDialog(
                context: context, 
                title: state.permissionParams!.title, 
                message: state.permissionParams!.content,
                yesButtonName: "OPEN" 
              ).then((value) {
                if (value!) {
                  state.permissionParams!.openSettings();
                }
              });
            } else if (state.result != null) {
              _navigateToSavingPage(context, state.result!);
            } else if (state.photo != null) {
              _openImageView(context, state);
            }
          },
          builder: (blocContext, state) {
            return _buildMainContent(blocContext, state);
          },
        ),
      ),
    );
  }

  Widget _backBtn(BuildContext context) {
    return TextButton(
      onPressed: () => context.read<SiteBloc>().add(PreviousTapShown()),
      child: Text("Hide", 
        style: AppStyle.paragraph(
          color: AppColor.onBackgroundColor,
          height: 1.0,
        ),
      ),
    );
  }

  Widget _targetWidget({
    String? txtName,
    TextStyle? nameStyle,
    Widget? name,
    String? txtValue,
    TextStyle? valueStyle,
    Widget? value,
    String? txtUnit,
    TextStyle? unitStyle,
    Widget? unit,
    double? progressValue,
  }) {
    assert(txtName != null || name != null);
    assert(txtValue != null || value != null);
    return Column(
      children: [
        name ?? Text(
          txtName!, 
          style: nameStyle ?? AppStyle.paragraph(),
        ),
        const SizedBox(height: 8.0),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            value ?? Text(
              txtValue!, 
              style: valueStyle ?? AppStyle.tracking_heading_1(),
            ),
            unit ?? Text(
              txtUnit ?? "", 
              style: unitStyle ?? AppStyle.tracking_heading_2(),
            ),
          ],
        ),
        progressValue != null ? Container(
          margin: const EdgeInsets.only(top: 12.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 250.0,
              child: LinearProgressIndicator(
                value: progressValue,
                semanticsLabel: 'Linear progress indicator',
                backgroundColor: AppColor.onBackgroundColor,
                minHeight: 8.0,
                valueColor: const AlwaysStoppedAnimation(Colors.blueAccent),
              ),
            ),
          ),
        ) : const SizedBox(),
      ],
    );
  }

  // Widget _buildTargetWidget(TrackingState state) {
  //   final param = state.trackingParams;
  //   if (param.selectedTarget.isDistance) {
  //     final map = MyUtils.getFormattedDistance(param.distance);
  //     return _targetWidget(
  //       txtName: "Distance",
  //       txtValue: map["value"],
  //       txtUnit: map["unit"],
  //       progressValue: param.distance / param.targetValue!,
  //     );
  //   }
  //   if (param.selectedTarget.isCalories) {
  //     final map = MyUtils.getFormattedDistance(param.distance);
  //     return _targetWidget(
  //       txtName: "Calories",
  //       txtValue: "${param.workoutCalories}",
  //       txtUnit: map["cal"],
  //       progressValue: param.workoutCalories / param.targetValue!,
  //     );
  //   }
  //   return TimeCounter(
  //     timeStream: state.timeStream!,
  //     builder: (secondsElapsed) {
  //       return _targetWidget(
  //         txtName: "Duration",
  //         txtValue: MyUtils.getFormattedDuration(secondsElapsed),
  //         progressValue: param.targetValue == null 
  //             ? null
  //             : secondsElapsed / param.targetValue!
  //       );
  //     },
  //   );
  // }

  Widget _buildMainContent(BuildContext context, TrackingState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: <Widget>[
                _googleMapWidget(
                  context: context,
                  state: state,
                ),
                state.status.isInitial
                    ? _targetSelectionWidget(
                        context,
                        state.trackingParams.selectedTarget,
                      )
                    : const SizedBox(),
                !state.status.isInitial
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20.0,
                            ),
                            width: double.infinity,
                            margin: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100.withOpacity(0.65),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(AppStyle.borderRadius),
                              ),
                            ),
                            // child: _buildTargetWidget(state),
                          ),
                        ],
                      )
                    : const SizedBox(),
                !state.status.isInitial
                    ? ValueListenableBuilder(
                        builder: (context, value, child) {
                          // return Offstage(
                          //   offstage: value,
                          //   child: MeasurementPage(
                          //     trackingParams: state.trackingParams,
                          //     timeStream: state.timeStream!,
                          //     targetWidget: _buildTargetWidget(state),
                          //   ),
                          // );
                          return const SizedBox();
                        },
                        valueListenable: _visibilityChange,
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColor.secondaryColor,
            boxShadow: [
              BoxShadow(
                color: AppColor.onBackgroundColor,
                blurRadius: 4.0,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: _trackingButtonWidgets(
            context,
            state.status,
            state.trackingParams.selectedTarget,
          ),
        ),
      ],
    );
  }

  Widget _dropdownButtonWidget(
      BuildContext context, TrackingTarget selectedTarget) {
    return DropdownButton<TrackingTarget>(
      borderRadius: BorderRadius.circular(AppStyle.borderRadius),
      dropdownColor: AppColor.backgroundColor,
      elevation: 4,
      icon: Icon(
        Icons.arrow_drop_down_rounded,
        color: Colors.grey.shade400,
        size: 36.0,
      ),
      value: selectedTarget,
      alignment: AlignmentDirectional.center,
      underline: const SizedBox(),
      onChanged: (value) => context
          .read<ActivityTrackingBloc>()
          .add(DropDownItemSelected(value!)),
      selectedItemBuilder: (context) {
        return TrackingTarget.values
            .map(
              (type) => Center(
                child: Text(
                  type.stringValue,
                  style: AppStyle.paragraph(),
                ),
              ),
            )
            .toList();
      },
      items: TrackingTarget.values
          .map((type) => DropdownMenuItem<TrackingTarget>(
                value: type,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        type.stringValue,
                        style: selectedTarget == type
                            ? AppStyle.paragraph(color: AppColor.primaryColor)
                            : AppStyle.paragraph(),
                      ),
                    ),
                    selectedTarget == type
                        ? const Icon(
                            Icons.check_rounded,
                            color: AppColor.primaryColor,
                            size: 24.0,
                          )
                        : const SizedBox(),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _textFieldWidget(
      {required TextEditingController controller, int maxLength = 1}) {
    return SizedBox(
      width: maxLength * 32.0,
      child: TextField(
        controller: controller,
        style: AppStyle.tracking_heading_1(),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: const InputDecoration(
          isCollapsed: true,
          border: InputBorder.none,
          counter: SizedBox(),
        ),
        keyboardType: TextInputType.number,
        maxLength: maxLength,
        maxLines: 1,
        minLines: 1,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _targetSelectionWidget(
      BuildContext context, TrackingTarget selectedTarget) {
    final Widget inputWidget;
    if (selectedTarget.isDistance) {
      inputWidget = _distanceTargetInputWidget();
    } else if (selectedTarget.isDuration) {
      inputWidget = _durationTargetInputWidget();
    } else if (selectedTarget.isCalories) {
      inputWidget = _caloriesTargetWidget();
    } else {
      inputWidget = _noTargetInputWidget();
    }

    return Container(
      width: double.maxFinite,
      height: MediaQuery.of(context).size.height / 3,
      margin: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
          color: Colors.grey.shade100.withOpacity(0.65),
          borderRadius:
              const BorderRadius.all(Radius.circular(AppStyle.borderRadius))),
      child: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional.topCenter,
            child: _dropdownButtonWidget(context, selectedTarget),
          ),
          Align(
            alignment: AlignmentDirectional.center,
            child: inputWidget,
          ),
        ],
      ),
    );
  }

  Widget _distanceTargetInputWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        _textFieldWidget(controller: _txtDistanceWhole, maxLength: 3),
        Text(".", style: AppStyle.tracking_heading_2()),
        _textFieldWidget(controller: _txtDistanceFractional, maxLength: 1),
        Text(Metrics.distance.unit, style: AppStyle.tracking_heading_2()),
      ],
    );
  }

  Widget _durationTargetInputWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _textFieldWidget(controller: _txtDurationHour, maxLength: 2),
        Text(
          ":",
          style: AppStyle.tracking_heading_2(),
        ),
        _textFieldWidget(controller: _txtDurationMinute, maxLength: 2),
        Text(":", style: AppStyle.tracking_heading_2()),
        _textFieldWidget(controller: _txtDurationSecond, maxLength: 2),
      ],
    );
  }

  Widget _caloriesTargetWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _textFieldWidget(controller: _txtCalories, maxLength: 3),
        Text(Metrics.calories.unit, style: AppStyle.tracking_heading_2()),
      ],
    );
  }

  Widget _noTargetInputWidget() {
    return Text(
      "Boost your training with a workout target.",
      style: AppStyle.tracking_heading_2(),
      textAlign: TextAlign.center,
    );
  }

  double? _getTargetValue(TrackingTarget targetType) {
    if (targetType.isDistance) {
      return double.parse(_txtDistanceWhole.text) +
          double.parse(_txtDistanceFractional.text);
    }
    if (targetType.isCalories) {
      return double.parse(_txtCalories.text);
    }
    if (targetType.isDuration) {
      final hours = int.parse(_txtDurationHour.text);
      final minutes = int.parse(_txtDurationMinute.text);
      final seconds = int.parse(_txtDurationSecond.text);
      return hours * 3600.0 + minutes * 60 + seconds;
    }
    return null;
  }

  Widget _googleMapWidget({
    required BuildContext context,
    required TrackingState state,
  }) {
    return GoogleMap(
      polylines: {
        Polyline(
          polylineId: const PolylineId("route"),
          visible: true,
          points: state.geoPoints,
          color: AppColor.primaryColor,
          width: 4,
        ),
      },
      mapType: MapType.normal,
      myLocationButtonEnabled: true,
      myLocationEnabled: state.result == null,
      markers: state.markers,
      initialCameraPosition: const CameraPosition(
        target: LatLng(0.0, 0.0),
        zoom: 18.0,
        tilt: 10.0,
      ),
      onMapCreated: (GoogleMapController controller) {
        context.read<ActivityTrackingBloc>().onMapCreated(controller);
      },
    );
  }

  Widget _trackingButtonWidget({
    required void Function() onTap,
    required double size,
    String? content,
    IconData? icon,
    bool isActive = false,
  }) {
    assert(content != null || icon != null);

    Color foregroundColor;
    Color backgroundColor;
    if (isActive) {
      foregroundColor = AppColor.primaryColor;
      backgroundColor = AppColor.secondaryColor;
    } else {
      foregroundColor = AppColor.secondaryColor;
      backgroundColor = AppColor.primaryColor;
    }
    Widget child = icon == null
        ? Text(
            content!,
            style: AppStyle.paragraph(color: foregroundColor, fontSize: 14.0),
          )
        : Icon(icon, size: 24, color: foregroundColor);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(size * size / 2),
          border: Border.all(color: AppColor.primaryColor, width: 2.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 8.0,
              color: AppColor.dropShadowColor,
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }

  void _navigateToSavingPage(BuildContext context, TrackingResult result) async {
    await Navigator.pushNamed<bool>(context, "/saveForm", arguments: result).then((value) {
      if(value != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Post added successfully"),
          action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              
            },
          ),
        ));
        return context.read<ActivityTrackingBloc>().add(TrackingSaved(value));
      }
      context.read<ActivityTrackingBloc>().add(const RefreshTracking());
    });
  }

  void _openImageView(BuildContext context, TrackingState state) {
    final photo = state.photo!;
    Navigator.push<void>(context, MaterialPageRoute(
      builder: (context) => ImageView(
        file: state.photo!,
        onEdited: (originalBytes, editedBytes) => context
            .read<ActivityTrackingBloc>()
            .add(PhotoEdited(originalBytes, editedBytes)),
        onDelete: () => context
            .read<ActivityTrackingBloc>()
            .add(PhotoDeleted(photo)),
        onSave: () {
          
        },
      ),
    )).then((value) => context
        .read<ActivityTrackingBloc>()
        .add(const RefreshTracking())
    );
  }

  Widget _trackingButtonWidgets(
    BuildContext context,
    TrackingStatus status,
    TrackingTarget selectedTarget,
  ) {
    const btnS = 40.0, btnL = 76.0;
    final trackingBloc = context.read<ActivityTrackingBloc>();
    final List<Widget> buttons = [];
    Widget mapBtn = const SizedBox(), cameraBtn = const SizedBox();
    if (status.isInitial) {
      buttons.add(_trackingButtonWidget(
        onTap: () {
          final value = _getTargetValue(selectedTarget);
          trackingBloc.add(TrackingStarted(value));
        },
        size: btnL,
        content: "START",
      ));
    } else if (status.isStarted) {
      buttons.add(
        _trackingButtonWidget(
          onTap: () => trackingBloc.add(const TrackingPaused()),
          size: btnL,
          icon: Icons.square_sharp,
        ),
      );
    } else if (status.isPaused) {
      buttons.add(_trackingButtonWidget(
        onTap: () => trackingBloc.add(const TrackingResumed()),
        size: btnL,
        content: "RESUME",
        isActive: true,
      ));
      buttons.add(const SizedBox(width: 20.0));
      buttons.add(_trackingButtonWidget(
        onTap: () {
          context
            .read<ActivityTrackingBloc>()
            .add(const TrackingFinished());
        },
        size: btnL,
        content: "FINISH",
      ));
    }
    if (!status.isInitial) {
      mapBtn = ValueListenableBuilder(
        builder: (context, value, child) {
          return _trackingButtonWidget(
            onTap: () => _visibilityChange.value = !_visibilityChange.value,
            size: btnS,
            icon: Icons.location_on_outlined,
            isActive: !value,
          );
        },
        valueListenable: _visibilityChange,
      );
      cameraBtn = _trackingButtonWidget(
        onTap: () async {
          final value = await Navigator.pushNamed<PhotoParams>(context, "/camera");
          if(value != null) trackingBloc.add(PictureTaken(value));
        },
        size: btnS,
        icon: Icons.camera_alt_outlined,
        isActive: false,
      );
    }
    return Row(
      children: [
        Expanded(child: Center(child: cameraBtn)),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: buttons,
        ),
        Expanded(child: Center(child: mapBtn)),
      ],
    );
  }

  // Future<void> showModalBottomSheetHelper(
  //     BuildContext context, ActivityItem selectedItem) {
  //   return showModalBottomSheet(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.vertical(
  //       top: Radius.circular(12),
  //     )),
  //     builder: (buildContext) {
  //       return Container(
  //         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //         child: Column(
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 const Text(
  //                   "Choose an Activity",
  //                   style: TextStyle(
  //                       fontSize: 24,
  //                       color: Colors.black,
  //                       fontWeight: FontWeight.bold),
  //                 ),
  //                 TextButton(
  //                   onPressed: () => Navigator.pop(buildContext),
  //                   child: const Text("Close",
  //                       style: TextStyle(fontSize: 18, color: Colors.grey)),
  //                 ),
  //               ],
  //             ),
  //             Expanded(
  //               child: ListView(
  //                 children: ActivityItem.values.map((item) {
  //                   return ListTile(
  //                     onTap: () {
  //                       Navigator.pop(buildContext);
  //                       context
  //                           .read<ActivityTrackingBloc>()
  //                           .add(SelectActivityCategory(item));
  //                     },
  //                     iconColor: Colors.grey.shade300,
  //                     textColor: Colors.grey,
  //                     selectedColor: Constants.primaryColor,
  //                     selected: selectedItem == item,
  //                     leading: SvgPicture.asset(
  //                       ActivityCategory.svgPaths[item]!,
  //                       width: 30.0,
  //                       color: selectedItem == item
  //                           ? Constants.primaryColor
  //                           : Colors.grey,
  //                     ),
  //                     title: Text(
  //                       ActivityCategory.names[item]!,
  //                       style: const TextStyle(
  //                         fontSize: 20,
  //                       ),
  //                     ),
  //                     trailing: selectedItem == item
  //                         ? const Icon(Icons.check_rounded)
  //                         : null,
  //                   );
  //                 }).toList(growable: false),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<void> _showImageDialog(BuildContext context, Uint8List bytes) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(image.date),
              // const SizedBox(height: 4),
              // Text(image.name),
              // const SizedBox(height: 8),
              Image.memory(bytes),
            ],
          ),
          actionsPadding: EdgeInsets.zero,
          actions: <Widget>[
            TextButton(
              child: const Text('Remove'),
              onPressed: () {
                Navigator.of(context).pop();
                // _removeImage(image, file);
              },
            ),
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
