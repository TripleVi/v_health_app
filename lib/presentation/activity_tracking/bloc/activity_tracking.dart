import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../../../main.dart';

abstract class ActivityTracking {
  double totalDistance = 0.0;
  double? instantSpeed;
  double avgSpeed = 0.0;
  double maxSpeed = 0.0;
  double? instantPace;
  double avgPace = 0.0;
  double maxPace = 0.0;
  int totalCalories = 0;
  bool isPaused = false;
  StreamSubscription? locationListener;
  late final DateTime startDate;

  void startRecording(void Function(List<Position> positions) onPositionsAcquired) {
    startDate = DateTime.now();
    backgroundService.invoke("trackingSessionCreated");
    backgroundService.invoke("locationUpdates");
    locationListener = backgroundService.on("positionsAcquired").listen(
      (event) => locationUpdatesHelper(event, onPositionsAcquired),
    );
  }

  void locationUpdatesHelper(
    Map<String, dynamic>? event,
    void Function(List<Position> positions) onPositionsAcquired,
  ) {
    final data = List.castFrom<dynamic, Position>(event!["data"]);
    onPositionsAcquired(data);
  }

  void pauseRecording() {
    isPaused = true;
    backgroundService.invoke("trackingStatesUpdated", {
      "state": "paused"
    });
  } 

  void resumeRecording() {
    isPaused = false;
    backgroundService.invoke("trackingStatesUpdated", {
      "state": "resumed"
    });
  }

  void stopRecording() {
    isPaused = false;
    backgroundService.invoke("trackingStatesUpdated", {
      "state": "stopped"
    });
    locationListener!.cancel();
  }

  void updateMetrics(Map<String, dynamic> metrics);
}