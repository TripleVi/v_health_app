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
  double totalCalories = 0;
  int totalSteps = 0;
  int activeTime = 0;
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
    super.startRecording();
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
      var duration = 0;
      for (var e in event!["data"]) {
        if(e["steps"] as int == 0) continue;
        totalSteps += e["steps"] as int;
        totalCalories += e["calories"] * 1.0; // kcal
        totalDistance += e["distance"] * 1.0; // m
        duration += e["activeTime"] as int; // s
        maxSpeed = math.max(maxSpeed, e["speed"]*1.0);
        workoutData.add(WorkoutData(
          speed: e["speed"]*1.0,
          time: activeTime+duration,
        ));
      }
      if(duration == 0) {
        if(instantSpeed == null || instantSpeed == 0.0) return;
        instantSpeed = 0.0;
      }else {
        activeTime += duration;
        instantSpeed = workoutData.last.speed;
        avgSpeed = totalDistance / activeTime;
      }
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
    super.resumeRecording();
    backgroundService.invoke("trackingStatesUpdated", {
      "state": "resumed"
    });
  }

  @override
  void stopRecording() {
    super.stopRecording();
    backgroundService.invoke("trackingStatesUpdated", {
      "state": "stopped"
    });
    accelListener!.cancel();
    locationListener!.cancel();
  }
}