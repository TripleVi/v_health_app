part of 'camera_cubit.dart';

@immutable
sealed class CameraState {
  const CameraState();
}

final class CameraInitial extends CameraState {
  const CameraInitial();
}

final class CameraLoaded extends CameraState {
  final CameraController controller;
  final bool isProcessing;
  final String? errorMsg;

  const CameraLoaded({
    required this.controller, 
    this.isProcessing = false,
    this.errorMsg,
  });

  CameraLoaded copyWith({
    CameraController? controller,
    bool isProcessing = false,
    String? errorMsg,
  }) {
    return CameraLoaded(
      controller: controller ?? this.controller,
      isProcessing: isProcessing,
      errorMsg: errorMsg,
    );
  }
}

final class CameraSuccess extends CameraState {
  final PhotoParams pictureParams;

  const CameraSuccess(this.pictureParams);
}
