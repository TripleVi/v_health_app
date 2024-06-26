import "dart:async";
import "dart:io";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import "package:v_health/core/enum/bottom_navbar.dart";

import "../../../core/enum/activity_category.dart";
import "../../../core/enum/activity_tracking.dart";
import "../../../core/enum/metrics.dart";
import "../../../core/resources/style.dart";
import "../../../core/utilities/utils.dart";
import "../../camera/views/camera_page.dart";
import "../../site/bloc/site_bloc.dart";
import "../../widgets/app_bar.dart";
import "../../widgets/dialog.dart";
import "../bloc/activity_tracking_bloc.dart";
import "../../widgets/image_page.dart";
import "../saving/view/saving_page.dart";
import "time_counter.dart";
import "metrics_page.dart";

class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ActivityTrackingBloc>(
      create: (context) => ActivityTrackingBloc(),
      child: BlocListener<SiteBloc, SiteState>(
        listener: (context, state) {
          if(state.currentTab.isTracking || state.previousTab.isTracking) {
            context.read<ActivityTrackingBloc>().add(const TogglePage());
          }
        },
        child: Navigator(
          onGenerateRoute: (settings) {
            if(settings.name == "/tracking") {
              return MaterialPageRoute<void>(
                builder: (context) => TrackingView(),
                settings: settings,
              );
            }
            if(settings.name == "/postForm") {
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
      ),
    );
  }
}

class TrackingView extends StatelessWidget {
  final _txtDistanceWhole = TextEditingController(text: "1");
  final _txtDistanceFractional = TextEditingController(text: "0");
  final _txtDurationHour = TextEditingController(text: "01");
  final _txtDurationMinute = TextEditingController(text: "00");
  final _txtDurationSecond = TextEditingController(text: "00");
  final _txtCalories = TextEditingController(text: "01");

  TrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      appBar: CustomAppBar.get(
        title: "Tracking",
        leading: _backBtn(context),
      ),
      body: BlocConsumer<ActivityTrackingBloc, ActivityTrackingState>(
        listener: (blocContext, state) {
          if (state.request != null) {
            MyDialog.showTwoOptionsDialog(
              context: context, 
              title: state.request!.title, 
              message: state.request!.description,
              yesButtonName: "OPEN"
            ).then((value) {
              if (value!) {
                state.request!.openSettings();
              }
            });
          } else if (state.result != null) {
            _navigateToSavingPage(context, state.result!);
          } else if (state.photo != null) {
            _openImageView(context, state);
          } else if (state.recState.isPaused && !state.isQualified) {
            MyDialog.showTwoOptionsDialog(
              context: context, 
              title: "Warning", 
              message: "Your workout is too short to save.",
              yesButtonName: "Continue",
              noButtonName: "Stop",
            ).then((value) {
              if(value == false) {
                context
                    .read<ActivityTrackingBloc>().add(const TrackingDestroyed());
              }
            });
          } else if (state.snackMsg != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: AppStyle.surfaceColor,
              showCloseIcon: true,
              closeIconColor: AppStyle.secondaryIconColor,
              content: Text(
                state.snackMsg!,
                style: AppStyle.bodyText(),
              ),
            ));
          }
        },
        builder: (blocContext, state) {
          return _buildMainContent(blocContext, state);
        },
      ),
    );
  }

  Widget _backBtn(BuildContext context) {
    return TextButton(
      onPressed: () => context.read<SiteBloc>().add(PreviousTapShown()),
      child: const Text("Hide"),
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
          style: nameStyle ?? AppStyle.caption1(),
        ),
        const SizedBox(height: 8.0),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            value ?? Text(
              "$txtValue ", 
              style: valueStyle ?? AppStyle.heading2(),
            ),
            unit ?? Text(
              txtUnit ?? "", 
              style: unitStyle ?? AppStyle.heading5(),
            ),
          ],
        ),
        progressValue != null ? Container(
          margin: const EdgeInsets.only(top: 12.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppStyle.borderRadius),
            child: SizedBox(
              width: 250.0,
              child: LinearProgressIndicator(
                value: progressValue,
                semanticsLabel: "Linear progress indicator",
                backgroundColor: AppStyle.neutralColor300,
                minHeight: 8.0,
                valueColor: const AlwaysStoppedAnimation(AppStyle.primaryColor),
              ),
            ),
          ),
        ) : const SizedBox(),
      ],
    );
  }

  Widget _buildTargetWidget(ActivityTrackingState state) {
    final params = state.trackingParams;
    if (params.selectedTarget.isDistance) {
      final map = MyUtils.getFormattedDistance(params.distance);
      return _targetWidget(
        txtName: "Distance",
        txtValue: map["value"],
        txtUnit: map["unit"],
        progressValue: params.distance / params.targetValue!,
      );
    }
    if (params.selectedTarget.isCalories) {
      final map = MyUtils.getFormattedDistance(params.distance);
      return _targetWidget(
        txtName: "Calories",
        txtValue: "${params.calories}",
        txtUnit: map["cal"],
        progressValue: params.calories / params.targetValue!,
      );
    }
    return TimeCounter(
      timeStream: state.timeStream!,
      builder: (secondsElapsed) {
        return _targetWidget(
          txtName: "Duration",
          txtValue: MyUtils.getFormattedDuration(secondsElapsed),
          progressValue: params.targetValue == null 
              ? null
              : secondsElapsed / params.targetValue!
        );
      },
    );
  }

  Widget _buildMainContent(BuildContext context, ActivityTrackingState state) {
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
                state.isLocationAvail 
                    ? _googleMapWidget(
                      context: context,
                      state: state,
                    ) 
                    : const SizedBox(),
                state.recState.isInitial
                    ? _targetSelectionWidget(
                        context,
                        state.trackingParams.selectedTarget,
                      )
                    : const SizedBox(),
                !state.recState.isInitial
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            width: double.infinity,
                            margin: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: AppStyle.surfaceColor.withOpacity(0.6),
                              borderRadius: const BorderRadius
                                  .all(Radius.circular(AppStyle.borderRadius)),
                            ),
                            child: _buildTargetWidget(state),
                          ),
                        ],
                      )
                    : const SizedBox(),
                state.isMetricsVisible
                    ? MetricsPage(
                      trackingParams: state.trackingParams,
                      timeStream: state.timeStream!,
                      targetWidget: _buildTargetWidget(state),
                    )
                    : const SizedBox(),
                state.recState.isInitial
                    ? Align(
                      alignment: const Alignment(0.9, -0.6),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _categoryBtn(context, state),
                        ],
                      ),
                    )
                    : const SizedBox(),
                state.isLocationAvail
                    ? const SizedBox()
                    : Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.lightBlue.shade200.withOpacity(0.3),
                    ),
              ],
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: AppStyle.surfaceColor,
            boxShadow: [
              BoxShadow(
                color: AppStyle.neutralColor400,
                blurRadius: 4.0,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: _trackingButtonWidgets(context, state),
        ),
      ],
    );
  }

  Widget _categoryBtn(BuildContext context, ActivityTrackingState state) {
    return GestureDetector(
      onTap: () => _modalBottomSheetHelper(context, state),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: AppStyle.surfaceColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              blurRadius: 8.0,
              color: AppStyle.dropShadowColor,
            ),
          ],
        ),
        child: SvgPicture.asset(
          state.category.svgPaths,
          width: 24.0,
          colorFilter: const ColorFilter
              .mode(AppStyle.primaryColor, BlendMode.srcIn),
        )
      ),
    );
  }

  Widget _dropdownButtonWidget(
    BuildContext context, 
    TrackingTarget selectedTarget,
  ) {
    return DropdownButton<TrackingTarget>(
      borderRadius: BorderRadius.circular(AppStyle.borderRadius),
      dropdownColor: AppStyle.surfaceColor,
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
          .read<ActivityTrackingBloc>().add(DropDownItemSelected(value!)),
      selectedItemBuilder: (context) {
        return TrackingTarget.values
            .map(
              (type) => Center(
                child: Text(
                  type.stringValue,
                  style: AppStyle.bodyText(),
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
                            ? AppStyle.bodyText(color: AppStyle.primaryColor)
                            : AppStyle.bodyText(),
                      ),
                    ),
                    selectedTarget == type
                        ? const Icon(
                            Icons.check_rounded,
                            color: AppStyle.primaryColor,
                            size: 24.0,
                          )
                        : const SizedBox(),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _textFieldWidget({
    required TextEditingController controller, 
    int maxLength = 1,
  }) {
    return SizedBox(
      width: maxLength * 30.0,
      child: TextField(
        controller: controller,
        style: AppStyle.heading2(fontSize: 40.0, height: 1.0,letterSpacing: 0),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: null,
        keyboardType: TextInputType.number,
        maxLength: maxLength,
        maxLines: 1,
        minLines: 1,
        textAlign: TextAlign.right,
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
        Container(child: _textFieldWidget(controller: _txtDistanceWhole, maxLength: 3)),
        Text(".", style: AppStyle.caption2()),
        Container(child: _textFieldWidget(controller: _txtDistanceFractional, maxLength: 1)),
        Text(Metrics.distance.unit, style: AppStyle.caption2()),
      ],
    );
  }

  Widget _durationTargetInputWidget() {
    const fontSize = 32.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _textFieldWidget(controller: _txtDurationHour, maxLength: 2),
        Text(":", style: AppStyle.caption2(fontSize: fontSize)),
        _textFieldWidget(controller: _txtDurationMinute, maxLength: 2),
        Text(":", style: AppStyle.caption2(fontSize: fontSize)),
        _textFieldWidget(controller: _txtDurationSecond, maxLength: 2),
      ],
    );
  }

  Widget _caloriesTargetWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _textFieldWidget(controller: _txtCalories, maxLength: 3),
        Text(Metrics.calorie.unit, style: AppStyle.heading2(height: 1.0)),
      ],
    );
  }

  Widget _noTargetInputWidget() {
    return Text(
      "Boost your training with a workout target.",
      style: AppStyle.heading2(),
      textAlign: TextAlign.center,
    );
  }

  double? _getTargetValue(TrackingTarget targetType) {
    if (targetType.isDistance) {
      final distance = double.parse(_txtDistanceWhole.text) +
          double.parse(_txtDistanceFractional.text);
      return distance * 1000; // km to m
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
    required ActivityTrackingState state,
  }) {
    return GoogleMap(
      polylines: {
        Polyline(
          polylineId: const PolylineId("route"),
          visible: true,
          points: state.geoPoints,
          color: Colors.blue,
          width: 4,
        ),
      },
      mapType: MapType.normal,
      zoomControlsEnabled: false,
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
      foregroundColor = AppStyle.primaryColor;
      backgroundColor = AppStyle.surfaceColor;
    } else {
      foregroundColor = AppStyle.surfaceColor;
      backgroundColor = AppStyle.primaryColor;
    }
    Widget child = icon == null
        ? Text(
            content!,
            style: AppStyle.caption2(color: foregroundColor),
          )
        : Icon(icon, size: 20, color: foregroundColor);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(color: AppStyle.primaryColor, width: 2.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 8.0,
              color: AppStyle.dropShadowColor,
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }

  void _navigateToSavingPage(BuildContext context, TrackingResult result) async {
    Navigator.pushNamed<bool>(context, "/postForm", arguments: result)
        .then((value) {
          context.read<ActivityTrackingBloc>().add(TrackingSaved(value));
        });
  }

  void _openImageView(BuildContext context, ActivityTrackingState state) {
    Navigator.push<void>(context, MaterialPageRoute(
      builder: (context) => ImageView(
        file: File(state.photo!.path),
        onEdited: (originalBytes, editedBytes) {},
        // onEdited: (originalBytes, editedBytes) => context
        //     .read<ActivityTrackingBloc>()
        //     .add(PhotoEdited(originalBytes, editedBytes)),
        onDelete: () => context
            .read<ActivityTrackingBloc>()
            .add(PhotoDeleted(state.photo!)),
        onSave: () {},
      ),
    )).then((value) => context
        .read<ActivityTrackingBloc>()
        .add(const RefreshScreen())
    );
  }

  Widget _trackingButtonWidgets(
    BuildContext context,
    ActivityTrackingState state
  ) {
    const btnS = 40.0, btnL = 76.0;
    final trackingBloc = context.read<ActivityTrackingBloc>();
    final List<Widget> buttons = [];
    Widget mapBtn = const SizedBox(), cameraBtn = const SizedBox();
    if (state.recState.isInitial) {
      buttons.add(_trackingButtonWidget(
        onTap: () {
          final value = _getTargetValue(state.trackingParams.selectedTarget);
          trackingBloc.add(TrackingStarted(value));
        },
        size: btnL,
        content: "START",
      ));
    } else if (state.recState.isRecording) {
      buttons.add(
        _trackingButtonWidget(
          onTap: () => trackingBloc.add(const TrackingPaused()),
          size: btnL,
          icon: Icons.square_sharp,
        ),
      );
    } else if (state.recState.isPaused) {
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
    if (!state.recState.isInitial) {
      mapBtn = _trackingButtonWidget(
        onTap: () => context
            .read<ActivityTrackingBloc>()
            .add(const ToggleMetricsDialog()),
        size: btnS,
        icon: Icons.location_on_outlined,
        isActive: state.isMetricsVisible,
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

  Future<void> _modalBottomSheetHelper(
    BuildContext context, 
    ActivityTrackingState state,
  ) async {
    return showModalBottomSheet<ActivityCategory>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppStyle.borderRadius),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Choose an activity",
                    style: AppStyle.heading4(),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop<void>(context),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        color: AppStyle.sBtnBgColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 20.0,
                        color: AppStyle.primaryIconColor,
                      ),
                    )
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: ListView(
                  children: ActivityCategory.values.map((item) {
                    return ListTile(
                      onTap: () => Navigator.pop(context, item),
                      iconColor: AppStyle.secondaryIconColor,
                      textColor: AppStyle.secondaryTextColor,
                      titleTextStyle: AppStyle.bodyText(),
                      selectedColor: AppStyle.primaryColor,
                      selected: state.category == item,
                      leading: SvgPicture.asset(
                        item.svgPaths,
                        width: 24.0,
                        colorFilter: ColorFilter.mode(
                          state.category == item 
                              ? AppStyle.primaryColor 
                              : AppStyle.secondaryIconColor, 
                          BlendMode.srcIn,
                        ),
                      ),
                      title: Text(item.name),
                      trailing: state.category == item
                          ? const Icon(Icons.check_rounded, size: 20.0)
                          : null,
                    );
                  }).toList(growable: false),
                ),
              ),
            ],
          ),
        );
      },
    ).then<void>((value) {
      if(value == null) return;
      context.read<ActivityTrackingBloc>().add(CategorySelected(value));
    });
  }
}
