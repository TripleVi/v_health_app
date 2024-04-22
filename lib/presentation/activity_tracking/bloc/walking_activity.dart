import "dart:async";
import "dart:math" as math;

import "../../../domain/entities/workout_data.dart";
import "../../../main.dart";
import "activity_tracking.dart";

class WalkingActivity extends ActivityTracking {
  int totalSteps = 0;
  StreamSubscription? accelListener;
  StreamSubscription? locationListener;
  void Function(List<Map> positions)? onPositionsAcquired;
  void Function()? onMetricsUpdated;

  WalkingActivity({
    this.onPositionsAcquired,
    this.onMetricsUpdated,
  });

  void handleLocationUpdates() {
    backgroundService.invoke("locationUpdates");
    locationListener = backgroundService.on("positionsAcquired").listen(
      (event) {
        for (var p in event!["data"]) {
          p["latitude"] *= 1.0;
          p["longitude"] *= 1.0;
          p["accuracy"] *= 1.0;
        }
        onPositionsAcquired??(event["data"]);
      },
    );
  }

  void handleAccelerationUpdate() {
    backgroundService.invoke("accelUpdates");
    accelListener = backgroundService.on("accelAcquired").listen((event) async {
      var totalDistance = 0.0, totalCalories = 0.0, totalSteps = 0;
      var maxSpeed = 0;
      for (var e in event!["data"]) {
        final speed = e["speed"] * 1.0; // m/s
        final steps = e["steps"] as int;
        final calories = e["calories"] * 1.0; // kcal
        final distance = e["distance"] * 1.0;
        final timeFrame = e["timeFrame"];
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
      onMetricsUpdated??();
    });
  }

  @override
  void startRecording() {
    super.startRecording();
    handleLocationUpdates();
    handleAccelerationUpdate();
  }

  @override
  void stopRecording() {
    super.stopRecording();
    accelListener!.cancel();
    locationListener!.cancel();
  }
}