// import 'dart:async';
// import 'package:sqflite/sqflite.dart';

// import '../../data/sources/table_attributes.dart';
// import '../../data/sources/sqlite/sqlite_service.dart';
// import '../../domain/entities/accel_data.dart';
// import '../utilities/utils.dart';

// class SensorService {
//   static final SensorService instance = SensorService.init();

//   SensorService.init();

//   static List<AccelData> events = [];

//   static List<AccelData> activeEvents = [];

//   static StreamSubscription? accel;

//   static StreamSubscription? activeAccel;

//   void attach() {
//     if (accel == null) {
//       accel = userAccelerometerEvents.listen((event) {
//         events.add(AccelData.fromEvent(event));
//       });
//     } else {
//       accel!.resume();
//     }
//   }

//   Future<int> getLength() async {
//     return events.length;
//   }

//   void clearList() {
//     events.clear();
//   }

//   void clearActive() {
//     activeEvents.clear();
//   }

//   List<AccelData> fetchEvents() {
//     List<AccelData> data = List.from(events);
//     return data;
//   }

//   List<AccelData> fetchActiveEvents() {
//     List<AccelData> data = List.from(activeEvents);
//     return data;
//   }

//   void attachActive() {
//     if (activeEvents.isNotEmpty) {
//       activeEvents.clear();
//       return;
//     } else {
//       activeAccel = userAccelerometerEvents.listen((event) {
//         activeEvents.add(AccelData.fromEvent(event));
//       });
//     }
//   }

//   void pauseActive() {
//     activeAccel?.pause();
//   }

//   void stopActive() {
//     activeAccel?.cancel();
//   }

  

//   Future<List<AccelData>> addQuarterBatch() async {
//     List<AccelData> quarterEvents = List.from(events);
//     events.clear();
//     final database = await SqlService.instance.database;

//     final Batch batch = database.batch();
//     for (var event in quarterEvents) {
//       batch.insert(AccelDataFields.table, event.toJson());
//     }

//     await batch.commit();
//     return quarterEvents;
//   }

//   Future<String> exportToText() async {
//     List<AccelData> events2 = List.from(events);
//     events.clear();
//     List<List<dynamic>> rows = [];
//     for (int i = 0; i < events2.length; i++) {
//       List<dynamic> row = [];
//       row.add(events2[i].x.toStringAsFixed(2));
//       row.add(events2[i].y.toStringAsFixed(2));
//       row.add(events2[i].z.toStringAsFixed(2));
//       row.add(events2[i].t);
//       rows.add(row);
//     }
//     final file = await MyUtils.getLocalFile(
//         'accelerator', DateTime.now().millisecondsSinceEpoch);
//     String csv = const ListToCsvConverter().convert(rows);
//     await file.writeAsString(csv);
//     return "${file.path}; Total rows: ${rows.length}";
//   }

//   void uploadData() async {
//     final database = await SqlService.instance.database;
//     final Batch batch = database.batch();

//     for (var event in events) {
//       batch.insert(AccelDataFields.table, event.toMap());
//     }

//     await batch.commit();
//   }

//   void pause() {
//     accel?.pause();
//   }

//   void dispose() {
//     accel?.cancel();
//   }
// }

import 'package:flutter_sensors/flutter_sensors.dart';

class SensorService {
  SensorService();

  Future<Stream<List<double>>> accelerometerEvents() async {
    // SENSOR_DELAY_GAME: real sampling rate = 30 Hz
    // SENSOR_DELAY_FASTEST: real sampling rate = 100 Hz
    return (await SensorManager().sensorUpdates(
      sensorId: Sensors.ACCELEROMETER, 
      interval: Sensors.SENSOR_DELAY_GAME,
    ))
    .map((e) => [e.data[0]/9.8, e.data[1]/9.8, e.data[2]/9.8]);
  }
}