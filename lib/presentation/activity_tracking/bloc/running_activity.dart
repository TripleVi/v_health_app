// import 'dart:async';

// import 'package:geolocator/geolocator.dart';

// import '../../../core/services/classification_service.dart';
// import '../../../main.dart';
// import 'activity_tracking.dart';

// class RunningActivity extends ActivityTracking {
//   int totalSteps = 0;
//   StreamSubscription? accelListener;

//   @override
//   void startRecording({
//     required void Function() onMetricsUpdated, 
//     required void Function(List<Position> positions) onPositionsAcquired,
//   }) {
//     initSession();
//     handleLocationUpdates(onPositionsAcquired);
//     backgroundService.invoke("accelUpdates");
//     accelListener = backgroundService.on("accelAcquired").listen((e) async {
//       final data = (e!["data"] as List).map((e) => 
//           (e as List).map<double>((e) => e*1.0).toList(growable: false)
//       ).toList(growable: false);
//       final service = ClassificationService();
//       final time = DateTime.now().difference(startDate).inSeconds;
//       final metrics = await service.classify(data, data.length/activeInterval);
//       metrics["time"] = time;
//       metrics["duration"] = activeInterval;
//       updateMetrics(metrics);
//       onMetricsUpdated();
//     });
//   }

//   @override
//   void updateMetrics(Map<String, dynamic> metrics) {
//     final steps = metrics["steps"] as int;
//     final distance = metrics["distance"] as double;
//     final calories = metrics["calories"] as double;
//     final secondsElapsed = metrics["time"] as int;
//     final duration = metrics["duration"] as int;
//     totalSteps += steps;
//     // m
//     totalDistance += distance;
//     // m/s
//     instantSpeed = distance / duration;
//     avgSpeed = totalDistance / secondsElapsed;
//     if(instantSpeed! > maxSpeed) {
//       maxSpeed = instantSpeed!;
//     }
//     // s/m
//     instantPace = duration / distance;
//     avgPace = secondsElapsed / totalDistance;
//     if(instantPace! > maxPace) {
//       maxPace = instantPace!;
//     }
//     // kcal
//     totalCalories += calories.round();
//   }

//   @override
//   void stopRecording() {
//     super.stopRecording();
//     accelListener!.cancel();
//   }
// }
