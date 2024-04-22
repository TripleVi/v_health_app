import "../../../domain/entities/workout_data.dart";
import "../../../main.dart";

abstract class ActivityTracking {
  double totalDistance = 0.0;
  double? instantSpeed;
  double avgSpeed = 0.0;
  double maxSpeed = 0.0;
  double? instantPace;
  double avgPace = 0.0;
  double maxPace = 0.0;
  double totalCalories = 0.0;
  bool isPaused = false;
  List<WorkoutData> workoutData = [];
  late final DateTime startDate;

  void startRecording() {
    startDate = DateTime.now();
    backgroundService.invoke("trackingSessionCreated");
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
  }
}

class ActivityPosition {
  double latitude;
  double longitude;
  double accuracy;

  ActivityPosition(this.latitude, this.longitude, this.accuracy);
}