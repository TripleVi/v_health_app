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

  void initSession() {
    startDate = DateTime.now();
    backgroundService.invoke("trackingSessionCreated");
  }

  void startRecording({
    required void Function() onMetricsUpdated,
    required void Function(List<Position> positions) onPositionsAcquired,
  });

  void handleLocationUpdates(
    void Function(List<Position> positions) onPositionsAcquired
  ) {
    backgroundService.invoke("locationUpdates");
    locationListener = backgroundService.on("positionsAcquired").listen(
      (event) {
        final positions = (event!["data"] as List).map((e) {
          e["latitude"] *= 1.0;
          e["longitude"] *= 1.0;
          e["accuracy"] *= 1.0;
          e["altitude"] *= 1.0;
          e["altitude_accuracy"] *= 1.0;
          e["heading"] *= 1.0;
          e["heading_accuracy"] *= 1.0;
          e["speed"] *= 1.0;
          e["speed_accuracy"] *= 1.0;
          return Position.fromMap(e);
        }).toList();
        onPositionsAcquired(positions);
      },
    );
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