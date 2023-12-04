import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/resources/colors.dart';
import '../../activity_tracking/bloc/activity_tracking_bloc.dart';
import '../../widgets/dialog.dart';
import '../../widgets/loading_indicator.dart';
import '../cubit/camera_cubit.dart';

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
          if (state is CameraLoaded && state.errorMsg != null) {
            MyDialog.showSingleOptionsDialog(
              context: context, 
              title: "Camera Services", 
              message: state.errorMsg!,
            );
          }
        },
        builder: (context, state) {
          if (state is CameraInitial) {
            return const SizedBox(height: 32.0, child: AppLoadingIndicator());
          }
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
      margin: const EdgeInsets.only(right: 8.0, bottom: 12.0),
      child: TextButton(
        onPressed: () {
          Navigator.pop<PhotoParams>(context, params);
          SystemChrome.setEnabledSystemUIMode(
            SystemUiMode.manual,
            overlays: SystemUiOverlay.values,
          );
        },
        style: TextButton.styleFrom(
          backgroundColor: AppColor.backgroundColor,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(8.0),
        ),
        child: const Icon(
          Icons.send_rounded,
          size: 32.0,
          color: AppColor.primaryColor,
        ),
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
        Align(
          alignment: Alignment.topCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop<void>(context);
                  SystemChrome.setEnabledSystemUIMode(
                    SystemUiMode.manual,
                    overlays: SystemUiOverlay.values,
                  );
                },
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  size: 30.0,
                  color: AppColor.secondaryColor,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.flip_camera_android_rounded,
                  size: 30.0,
                  color: AppColor.secondaryColor,
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.only(right: 30.0),
            padding: const EdgeInsets.symmetric(vertical: 35.0),
            child: IconButton(
              onPressed: () => context.read<CameraCubit>().captureCamera(),
              icon: const Icon(
                Icons.radio_button_checked_rounded,
                color: AppColor.secondaryColor,
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
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            onPressed: () => context.read<CameraCubit>().deletePicture(),
            icon: const Icon(
              Icons.close_rounded,
              size: 30.0,
              color: AppColor.secondaryColor,
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
