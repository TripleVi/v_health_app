import "dart:io" as io;

import "package:flutter/material.dart";
import "package:camera/camera.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../core/resources/style.dart";
import "../../activity_tracking/bloc/activity_tracking_bloc.dart";
import "../cubit/camera_cubit.dart";

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CameraCubit>(
      create: (context) => CameraCubit(),
      child: const CameraView(),
    );
  }
}

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: BlocConsumer<CameraCubit, CameraState>(
        listener: (context, state) {
          if(state is CameraLoaded && state.snackMsg != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: AppStyle.backgroundColor,
              showCloseIcon: true,
              closeIconColor: AppStyle.secondaryIconColor,
              content: Text(
                state.snackMsg!,
                style: AppStyle.bodyText(),
              ),
            ));
          }
        },
        builder: (context, state) {
          if (state is CameraLoaded) {
            return _buildCameraPreview(context, state);
          }
          if (state is CameraSuccess) {
            return _buildPictureTaken(context, state);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildSendBtn(BuildContext context, PhotoParams params) {
    return Container(
      margin: const EdgeInsets.only(right: 16.0, bottom: 16.0),
      child: IconButton(
        onPressed: () {
          Navigator.pop<PhotoParams>(context, params);
          // SystemChrome.setEnabledSystemUIMode(
          //   SystemUiMode.manual,
          //   overlays: SystemUiOverlay.values,
          // );
        },
        style: TextButton.styleFrom(
          backgroundColor: AppStyle.surfaceColor,
        ),
        iconSize: 32.0,
        color: AppStyle.primaryColor,
        icon: const Icon(Icons.send_rounded),
      ),
    );
  }

  Widget _buildCameraPreview(BuildContext context, CameraLoaded state) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CameraPreview(state.controller),
        ),
        Positioned(
          left: 0.0,
          right: 0.0,
          top: 20.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop<void>(context);
                  // SystemChrome.setEnabledSystemUIMode(
                  //   SystemUiMode.manual,
                  //   overlays: SystemUiOverlay.values,
                  // );
                },
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  size: 30.0,
                  color: AppStyle.surfaceColor,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.flip_camera_android_rounded,
                  size: 30.0,
                  color: AppStyle.surfaceColor,
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            child: IconButton(
              onPressed: () => context.read<CameraCubit>().captureCamera(),
              icon: const Icon(
                Icons.radio_button_checked_rounded,
                color: AppStyle.surfaceColor,
                size: 60.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPictureTaken(BuildContext context, CameraSuccess state) {
    final params = state.pictureParams;
    return Stack(
      children: [
        Image.file(
          io.File(params.file.path),
          width: double.maxFinite,
          height: double.maxFinite,
          filterQuality: FilterQuality.high,
          fit: BoxFit.fill,
          isAntiAlias: true,
        ),
        Positioned(
          left: 0.0,
          top: 20.0,
          child: IconButton(
            onPressed: () => context.read<CameraCubit>().deletePicture(),
            icon: const Icon(
              Icons.close_rounded,
              size: 30.0,
              color: AppStyle.surfaceColor,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: _buildSendBtn(context, params),
        ),
      ],
    );
  }
}
