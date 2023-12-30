import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../../../main.dart';

abstract class ActivityTracking {
  double totalDistance = 0.0;
  double? instantSpeed;
  double? avgSpeed;
  double maxSpeed = 0.0;
  double? instantPace;
  double? avgPace;
  double maxPace = 0.0;
  int totalCalories = 0;
  StreamSubscription? locationListener;
  late final DateTime startDate;

  void startTracking(void Function(List<Position> positions) onPositionsAcquired) {
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

  void pauseTracking() {
    backgroundService.invoke("trackingStatesUpdated", {
      "state": "paused"
    });
  } 

  void resumeTracking() {
    backgroundService.invoke("trackingStatesUpdated", {
      "state": "resumed"
    });
  }

  void stopTracking() {
    backgroundService.invoke("trackingStatesUpdated", {
      "state": "stopped"
    });
    locationListener!.cancel();
  }

  void updateMetrics(Map<String, dynamic> metrics);
}