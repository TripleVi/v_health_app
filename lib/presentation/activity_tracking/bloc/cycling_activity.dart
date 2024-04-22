// import 'package:geolocator/geolocator.dart';

// import 'activity_tracking.dart';

// class CyclingActivity extends ActivityTracking {
//   Position? curt;

//   @override
//   void startRecording({
//     required void Function() onMetricsUpdated, 
//     required void Function(List<Position> positions) onPositionsAcquired,
//   }) {
//     initSession();
//     handleLocationUpdates((positions) {
//       Position? prev;
//       if(positions.length == 1) {
//         prev = curt;
//         curt = positions.first;
//       }else {
//         curt = positions.last;
//         prev = positions[positions.length-1-1];
//       }
//       updateMetrics({
//         "prev": prev,
//         "curt": curt,
//       });
//       onPositionsAcquired(positions);
//     });
//     onMetricsUpdated();
//   }

//   @override
//   void updateMetrics(Map<String, dynamic> metrics) {
//     final prev = metrics["prev"] as Position;
//     final curt = metrics["curt"] as Position;
//     // m
//     final distance = Geolocator.distanceBetween(
//       prev.latitude, prev.longitude,
//       curt.latitude, curt.longitude,
//     );
//     totalDistance += distance;
//     // s
//     final duration = curt.timestamp!.difference(prev.timestamp!).inSeconds;
//     // m/s
//     instantSpeed = distance / duration;
//     final time = curt.timestamp!.difference(startDate).inSeconds;
//     avgSpeed = totalDistance / time;
//     if(instantSpeed! > maxSpeed) {
//       maxSpeed = instantSpeed!;
//     }
//     // s/m
//     instantPace = duration / distance;
//     avgPace = time / totalDistance;
//     if(instantPace! > maxPace) {
//       maxPace = instantPace!;
//     }
//     // final user = await userFuture;
//     var mETs = 0.0;
//     if(instantSpeed! >= 8.95) {
//       mETs = 15.8;
//     }else if(instantSpeed! >= 6.7) {
//       mETs = 10;
//     }else if(instantSpeed! >= 5.4) {
//       mETs = 8.5;
//     }else if(instantSpeed! >= 4.5) {
//       mETs = 6.8;
//     }else if(instantSpeed! >= 3.5) {
//       mETs = 5.8;
//     }else if(instantSpeed! >= 2.5) {
//       mETs = 3.5;
//     }
//     // kcal
//     // final calories = mETs * user.weight * (duration/3600);
//     // totalCalories += calories.round();
//   }
// }