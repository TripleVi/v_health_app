import "dart:async";
import "dart:math" as math;

import "../../../domain/entities/position.dart";
import "../../../domain/entities/workout_data.dart";
import "../../../main.dart";
import "fitness_activity.dart";

class WalkingActivity extends FitnessActivity {
  double totalDistance = 0.0;
  double? instantSpeed;
  double avgSpeed = 0.0;
  double maxSpeed = 0.0;
  double? instantPace;
  double avgPace = 0.0;
  double maxPace = 0.0;
  double totalCalories = 0;
  int totalSteps = 0;
  List<WorkoutData> workoutData = [];
  StreamSubscription? accelListener;
  StreamSubscription? locationListener;
  void Function() onMetricsUpdated;
  void Function(List<AppPosition>)? onPositionsAcquired;

  WalkingActivity({
    required this.onMetricsUpdated,
    this.onPositionsAcquired,
  });

  @override
  void startRecording() {
    backgroundService.invoke("trackingSessionCreated");
    handleLocationUpdates();
    handleAccelerationUpdate();
  }

  void handleLocationUpdates() {
    if(onPositionsAcquired == null) return;
    backgroundService.invoke("locationUpdates");
    locationListener = backgroundService.on("positionsAcquired").listen(
      (event) {
        final positions = (event!["data"] as List)
            .map((e) => AppPosition.fromMap(e)).toList();
        onPositionsAcquired!(positions);
      },
    );
  }

  void handleAccelerationUpdate() {
    backgroundService.invoke("accelUpdates");
    accelListener = backgroundService.on("accelAcquired").listen((event) async {
      var totalDistance = 0.0, totalCalories = 0, totalSteps = 0;
      var maxSpeed = 0;
      for (var e in event!["data"]) {
        final speed = e["speed"] * 1.0; // m/s
        final steps = e["steps"] as int;
        final calories = e["calories"] as int; // kcal
        final distance = e["distance"] * 1.0; // m
        final timeFrame = e["timeFrame"]; // s
        totalDistance += distance;
        totalCalories += calories;
        totalSteps += steps;
        maxSpeed = math.max(maxSpeed, speed);
        workoutData.add(WorkoutData(
          speed: speed,
          distance: distance,
          steps: steps,
          calories: totalCalories,
          timeFrame: timeFrame,
        ));
      }
      this.totalDistance += totalDistance;
      this.totalSteps += totalSteps;
      this.totalCalories += totalCalories;
      instantSpeed = event["data"].last["speed"];
      avgSpeed = totalDistance / workoutData.last.timeFrame;
      avgPace = 1 / avgSpeed;
      maxPace = 1 / maxSpeed;
      onMetricsUpdated();
    });
  }

  @override
  void pauseRecording() {
    backgroundService.invoke("trackingStatesUpdated", {
      "state": "paused"
    });
  } 

  @override
  void resumeRecording() {
    backgroundService.invoke("trackingStatesUpdated", {
      "state": "resumed"
    });
  }

  @override
  void stopRecording() {
    backgroundService.invoke("trackingStatesUpdated", {
      "state": "stopped"
    });

    accelListener!.cancel();
    locationListener!.cancel();
  }
}