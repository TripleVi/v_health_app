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
  final String? snackMsg;

  const CameraLoaded({
    required this.controller, 
    this.snackMsg,
  });

  CameraLoaded copyWith({
    CameraController? controller,
    String? snackMsg,
  }) {
    return CameraLoaded(
      controller: controller ?? this.controller,
      snackMsg: snackMsg,
    );
  }
}

final class CameraSuccess extends CameraState {
  final PhotoParams pictureParams;

  const CameraSuccess(this.pictureParams);
}
