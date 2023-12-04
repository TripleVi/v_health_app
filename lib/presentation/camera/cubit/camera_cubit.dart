import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/services/location_service.dart';
import '../../activity_tracking/bloc/activity_tracking_bloc.dart';

part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraController? _cameraController;

  CameraCubit() : super(const CameraInitial()) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );

    _initializeCamera();
  }
  
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset.max,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    await _cameraController!.initialize();
    emit(CameraLoaded(controller: _cameraController!));
  }

  void deletePicture() {
    emit(CameraLoaded(controller: _cameraController!));
  }

  Future<void> captureCamera() async {
    emit((state as CameraLoaded).copyWith(isProcessing: true));
    try {
      final file = await _cameraController!.takePicture();
      final locationService = GetIt.instance<LocationService>();
      final pos = await locationService.getCurrentPosition();
      if(pos != null) {
        final params = PhotoParams(
          file: file,
          latitude: pos.latitude,
          longitude: pos.longitude,
        );
        return emit(CameraSuccess(params));
      }
      emit((state as CameraLoaded).copyWith(errorMsg: "Cannot acquire your current position. Please try again!"));
    } catch (e) {
      print(e);
      emit((state as CameraLoaded).copyWith(errorMsg: "Something went wrong. Please try again!"));
    }
  }

  @override
  Future<void> close() async {
    await _cameraController?.dispose();
    await super.close();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
