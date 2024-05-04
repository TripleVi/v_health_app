import "package:camera/camera.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../core/services/location_service.dart";
import "../../activity_tracking/bloc/activity_tracking_bloc.dart";

part "camera_state.dart";

class CameraCubit extends Cubit<CameraState> {
  var isProcessing = false;
  CameraController? _cameraController;

  CameraCubit() : super(const CameraInitial()) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // SystemChrome.setEnabledSystemUIMode(
    //   SystemUiMode.manual,
    //   overlays: [SystemUiOverlay.bottom],
    // );
    
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
    if(isProcessing) return;
    isProcessing = true;
    try {
      final file = await _cameraController!.takePicture();
      final pos = await LocationService().getCurrentPosition();
      if(pos != null) {
        final params = PhotoParams(
          file: file,
          latitude: pos.latitude,
          longitude: pos.longitude,
        );
        return emit(CameraSuccess(params));
      }
      emit((state as CameraLoaded).copyWith(snackMsg: "Oops, cannot get your position."));
    } catch (e) {
      print(e);
      emit((state as CameraLoaded).copyWith(snackMsg: "Oops, something went wrong!"));
    } finally {
      isProcessing = false;
    }
  }

  @override
  Future<void> close() async {
    await _cameraController?.dispose();
    await super.close();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
