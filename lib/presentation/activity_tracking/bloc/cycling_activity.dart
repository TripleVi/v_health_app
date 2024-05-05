import "dart:async";
import "dart:math" as math;

import "../../../core/services/shared_pref_service.dart";
import "../../../core/utilities/constants.dart";
import "../../../domain/entities/position.dart";
import "../../../domain/entities/workout_data.dart";
import "../../../main.dart";
import "fitness_activity.dart";

class CyclingActivity extends FitnessActivity {
  double totalDistance = 0.0;
  double? instantSpeed;
  double avgSpeed = 0.0;
  double maxSpeed = 0.0;
  double totalCalories = 0;
  int activeTime = 0;
  List<WorkoutData> workoutData = [];
  StreamSubscription? locationListener;
  void Function(List<AppPosition>) onPositionsAcquired;

  CyclingActivity({
    required this.onPositionsAcquired,
  });

  @override
  void startRecording() {
    super.startRecording();
    backgroundService.invoke("trackingSessionCreated");
    handleLocationUpdates();
  }

  @override
  void pauseRecording() {
    super.pauseRecording();
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
    locationListener!.cancel();
  }

  void handleLocationUpdates() {
    backgroundService.invoke("locationUpdates");
    locationListener = backgroundService.on("positionsAcquired").listen(
      (event) async {
        final positions = (event!["data"] as List)
            .map((e) => AppPosition.fromMap(e)).toList();
        // remove initial position
        if(workoutData.isEmpty) {
          positions.removeAt(0);
        }
        final user = await SharedPrefService.getCurrentUser();
        var time = 0;
        final distance = Constants.distance * positions.length;
        for (var i = 1; i < positions.length; i++) {
          final duration = positions[i].timestamp
              .difference(positions[i-1].timestamp).inSeconds;
          final speed = distance / duration;
          if(i == positions.length-1) {
            instantSpeed = speed;
          }
          math.max(maxSpeed, speed);
          time += duration;
          // workoutData.add(WorkoutData(
          //   speed: speed,
          //   distance: distance + totalDistance,
          //   steps: 0,
          //   calories: totalCalories + calculateCalories(time, user.weight),
          //   time: duration + activeTime,
          // ));
        }
        avgSpeed = (avgSpeed + distance / time) / 2;
        totalDistance += distance;
        activeTime += time;
        totalCalories += calculateCalories(time, user.weight); 
        onPositionsAcquired(positions);
      },
    );
  }

  double calculateCalories(int time, double weight) {
    const cyclingMET = 9.5;
    return time * cyclingMET * 3.5 * weight / (200 * 60);
  }
}