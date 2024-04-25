abstract class FitnessActivity {
  bool isPaused = false;
  late final DateTime startDate;

  void startRecording() {
    startDate = DateTime.now();
  }

  void pauseRecording() {
    isPaused = true;
  } 

  void resumeRecording() {
    isPaused = false;
  }

  void stopRecording() {
    isPaused = false;
  }
}