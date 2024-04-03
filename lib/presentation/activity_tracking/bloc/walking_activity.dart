import 'dart:async';
import 'dart:math' as math;

import 'package:geolocator/geolocator.dart';

import '../../../domain/entities/workout_data.dart';
import '../../../main.dart';
import 'activity_tracking.dart';

class WalkingActivity extends ActivityTracking {
  int totalSteps = 0;
  StreamSubscription? accelListener;
  StreamSubscription? pressureListener;

  @override
  void startRecording({
    required void Function() onMetricsUpdated, 
    required void Function(List<Position> positions) onPositionsAcquired,
  }) {
    initSession();
    handleLocationUpdates(onPositionsAcquired);
    backgroundService.invoke("sensorsUpdates", {
      "acceleration": true,
      "pressure": false,
    });
    backgroundService.on("sensorsAcquired").listen((e) async {
      updateMetrics(e!);
      onMetricsUpdated();
    });
  }

  @override
  void updateMetrics(Map<String, dynamic> metrics) {
    final accel = metrics["acceleration"] as List;
    final time = DateTime.now().difference(startDate).inSeconds;
    var secondsElapsed = activeInterval;
    for (var i = 0; i < accel.length; i++) {
      // m
      double distance = accel[i]["distance"] * 1.0;
      // m/s
      double speed = distance / activeInterval;
      totalDistance += distance;
      totalSteps += accel[i]["steps"] as int;
      maxSpeed = math.max(maxSpeed, speed);
      workoutData.add(WorkoutData(
        speed: speed,
        totalDistance: totalDistance,
        timeFrame: secondsElapsed,
      ));
      secondsElapsed += activeInterval;
    }
    instantSpeed = workoutData.last.totalDistance / time;
    avgSpeed = totalDistance / time;
    // s/m
    avgPace = 1 / avgSpeed;
    maxPace = 1 / maxSpeed;
  }

  @override
  void stopRecording() {
    super.stopRecording();
    accelListener!.cancel();
  }
}