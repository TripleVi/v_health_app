import 'package:matrix2d/matrix2d.dart';

import '../../data/repositories/hourly_report_repo.dart';
import '../../domain/entities/report.dart';
import 'signal_filter_service.dart';
import 'user_service.dart';

class ClassifierService {
  ClassifierService();

  // int skip_step = 5;
  // int model_timesteps = 50;
  // String model_path = 'model_final_13_labels.tflite';
  // String model_path_120_batch = 'model_3rd_march.tflite';
  // String model_21st_march = 'model_21st_march.tflite';

  // double threshold = 0.2;
  // double resetValue = 0;

  // List<String> labels = [
  //   'Downstairs Chest',
  //   'Downstairs Waist',
  //   'Downstairs Pocket',
  //   'Running Chest',
  //   'Running Waist',
  //   'Running Pocket',
  //   'Standing',
  //   'Upstairs Chest',
  //   'Upstair Waist',
  //   'Upstairs Pocket',
  //   'Walking Chest',
  //   'Walking Waist',
  //   'Walking Pocket'
  // ];

  double getStrideByHeight(double height, int gender) {
    return gender == 1 ? height * 0.415 : height * 0.413;
  }

  double getRunningStrideByHeight(double height, int gender) {
    return gender == 1 ? height * 1.14 : height * 1.17;
  }

  double calculateCalories(int walk, int run, int climb_up, int climb_down) {
    return walk * 0.02 + run * 0.03 + climb_up * 0.04 + climb_down * 0.02;
  }

  // Future<List<AccelData>> loadClassifiedData() async {
  //   final dir = await pp.getExternalStorageDirectory();
  //   final path = p.join(dir!.path, Constants.classificationFileName);
  //   final io.File file = io.File(path);
  //   final lines = file.readAsLinesSync();

  //   List<AccelData> data = [];
  //   for (var line in lines) {
  //     var split = line.split('\t');
  //     data.add(AccelData(double.parse(split[0]), double.parse(split[1]),
  //         double.parse(split[2]), split[4]));
  //   }
  //   return data;
  // }

  // Future<Map<String, dynamic>> getSteps(List<dynamic> inputs) async {
  //   Butterworth b = Butterworth();
  //   b.lowPass(2, 120, 5);

  //   Database db = await SqlService.instance.database;
  //   final maps = await db.query(UserFields.container);
  //   if (maps.length != 1) {
  //     throw Exception("User does not exist");
  //   }
  //   User u = maps.isNotEmpty ? User.fromMap(maps.first) : User.empty();

  //   int w_steps = 0;
  //   int r_steps = 0;
  //   int u_steps = 0;
  //   int d_steps = 0;

  //   bool flag = true;
  //   // low pass for walking 2 - 70 - 5 - 1.8% deviant
  //   for (var input in inputs) {
  //     double x = b.filter(input.x);
  //     if (x >= threshold && flag) {
  //       if (input.activity.startsWith('Walking')) {
  //         w_steps += 1;
  //       } else if (input.activity.startsWith('Running')) {
  //         r_steps += 1;
  //       } else if (input.activity.startsWith('Upstairs')) {
  //         u_steps += 1;
  //       } else if (input.activity.startsWith('Downstairs')) {
  //         d_steps += 1;
  //       } else {
  //         continue;
  //       }
  //       flag = false;
  //     }
  //     if (x < resetValue && flag == false) {
  //       flag = true;
  //     }
  //   }

  //   return {
  //     'steps': w_steps + r_steps + u_steps + d_steps,
  //     'distance': (w_steps * getStrideByHeight(u.height, u.gender) +
  //             r_steps * getStrideByHeight(u.height, u.gender) * 0.17) /
  //         10,
  //     'calories': calculateCalories(w_steps, r_steps, u_steps, d_steps),
  //     'stair': u_steps + d_steps,
  //   };
  // }

  // String? labelOutput(List<dynamic> list) {
  //   double max = -double.infinity;
  //   int maxIndex = 0;
  //   for (int i = 0; i < list[0].length; i++) {
  //     if (list[0][i] > max) {
  //       max = list[0][i];
  //       maxIndex = i;
  //     }
  //   }
  //   return labels[maxIndex];
  // }

  // Future<List<dynamic>> convertToInput(List<dynamic> events) async {
  //   List<dynamic> input = [];
  //   for (int i = 0; i < events.length; i += skip_step) {
  //     List batch = [];
  //     List frame = [];
  //     for (int j = 0; j < model_timesteps; j += 1) {
  //       List<double> row = [];
  //       if (i < events.length - model_timesteps) {
  //         row.add(events[i + j].x);
  //         row.add(events[i + j].y);
  //         row.add(events[i + j].z);
  //       } else {
  //         row.add(events[i - j].x);
  //         row.add(events[i - j].y);
  //         row.add(events[i - j].z);
  //       }
  //       frame.add(row);
  //     }
  //     batch.add(frame);
  //     input.add(batch);
  //   }
  //   return input;
  // }

  // Future<List<dynamic>> convertToInput(List<dynamic> events) async {
  //   List<dynamic> input = [];
  //   for (int i = 0; i < events.length; i += skip_step) {
  //     List batch = [];
  //     List frame = [];
  //     for (int j = 0; j < model_timesteps; j += 1) {
  //       List<double> row = [];
  //       if (i < events.length - model_timesteps) {
  //         row.add(events[i + j].x);
  //         row.add(events[i + j].y);
  //         row.add(events[i + j].z);
  //       } else {
  //         row.add(events[i - j].x);
  //         row.add(events[i - j].y);
  //         row.add(events[i - j].z);
  //       }
  //       frame.add(row);
  //     }
  //     batch.add(frame);
  //     input.add(batch);
  //   }
  //   return input;
  // }

  List<List<List<double>>> _parse(List<List<double>> accelData, double samplingRate) {
    final filteredAccel = accelData.transpose.map((total) {
      final temp = List<double>.from(total);
      var gAccel = SignalFilterService.lowPassFilter(
        timeSeries: temp,
        samplingRate: samplingRate,
        cutoffFreq: 0.2,
      );
      const m2d = Matrix2d();
      final userAccel = m2d.subtraction(temp, gAccel);
      gAccel = gAccel.map((p) => p * -1).toList(growable: false);
      return [userAccel, gAccel];
    }).toList(growable: false);
    
    return List.generate(accelData.length, (i) {
      final userAccel = filteredAccel
          .map((arr) => arr[0][i] as double)
          .toList(growable: false);
      final gAccel = filteredAccel
          .map((arr) => arr[1][i] as double)
          .toList(growable: false);
      return [userAccel, gAccel];
    });
  }

  // Future<List<dynamic>> classify(
  //     List<dynamic> input, List<String> label) async {
  //   List<dynamic> labelled = [];
  //   Interpreter interpreter = await Interpreter.fromAsset(model_path);

  //   var output = List.filled(labels.length, 0).reshape([1, labels.length]);
  //   for (var i in input) {
  //     try {
  //       interpreter.run(i, output);
  //       labelled.add(labelOutput(output));
  //     } catch (e) {
  //       print(e);
  //     }
  //   }

  //   return labelled;
  // }

  // Future updateHourlyReport(List<dynamic> events, int hour, String date) async {
  //   Report r =
  //       await HourlyReportRepo.instance.fetchReportByDateAndHour(hour, date);
  //   Map<String, dynamic> results = await getSteps(events);
  //   if (r.id == '-1') {
  //     r.hour = hour;
  //     r.date = date;
  //     r.calories = results['calories'].round();
  //     r.distance = results['distance'];
  //     r.steps = results['steps'];
  //     r.stair = results['stair'];
  //     HourlyReportRepo.instance.addReport(r);
  //   } else {
  //     r.calories = (r.calories + results['calories'].round()) as int;
  //     r.distance = r.distance + results['distance'];
  //     r.steps = r.steps + results['steps'] as int;
  //     r.stair = r.stair + results['stair'] as int;
  //     HourlyReportRepo.instance.updateReport(hour, date, r);
  //   }
  // }

  Future<void> updateHourlyReport({
    required List<double> desiredAccelData, 
    required String date,
    required int hour, 
  }) async {
    final report = await HourlyReportRepo.instance.getHourlyReport(date, hour);
    final steps = _measureSteps(desiredAccelData);
    final user = await UserService.getCurrentUser();
    final strideLength = UserService.calculateUserStrideLength(user.gender, user.height);
    final distance = _measureDistance(steps, strideLength);
    if (report == null) {
      final newReport = Report.empty()
      ..date = date
      ..hour = hour
      ..steps = steps
      ..distance = distance;
      await HourlyReportRepo.instance.addReport(newReport);
      return;
    }
    report.distance += distance;
    report.steps += steps;
    await HourlyReportRepo.instance.updateReport(
      report: report,
      date: date,
      hour: hour,
    );
  }

  // Future generateReport(List<AccelData> events,
  //     {int hour = 1, String date = '2023/2/28'}) async {
  //   List<dynamic> input = await convertToInput(events);
  //   if (input.length < 50) {
  //     return [];
  //   }
  //   List<dynamic> labelled = await classify(input, labels);
  //   for (int i = 0; i < min(events.length, labelled.length); i += skip_step) {
  //     for (int j = 0; j < skip_step; j++) {
  //       events[i + j].activity = labelled[i];
  //     }
  //   }
  //   await updateHourlyReport(events, hour, date);
  // }

  Future<void> generateReport({
    required List<List<double>> rawAccelData,
    required String date,
    int hour = 1,
    required double samplingRate,
  }) async {
    if(rawAccelData.length < 50) return;
    final desiredData = _process(rawAccelData, samplingRate);
    return updateHourlyReport(
      desiredAccelData: desiredData,
      date: date,
      hour: hour,
    );
  }

  List<double> _process(List<List<double>> rawAccelData, double samplingRate) {
    final standardData = _parse(rawAccelData, samplingRate);
    var temp = _isolateUserAccelInDirOfG(standardData);
    //? Remove high-frequency components from jumpy peaks 
    temp = SignalFilterService.lowPassFilter(
      timeSeries: temp,
      samplingRate: samplingRate,
      cutoffFreq: 5.0,
    );
    //? Remove low-frequency components from slow peaks
    temp = SignalFilterService.highPassFilter(
      timeSeries: temp,
      samplingRate: samplingRate,
      cutoffFreq: 1.0,
    );
    return temp;
  }

  List<double> _isolateUserAccelInDirOfG(List<List<List<double>>> standardAccelData) {
    return standardAccelData
        .map((arr) => arr[0][0]*arr[1][0] + arr[0][1]*arr[1][1] + arr[0][2]*arr[1][2])
        .toList(growable: false);
  }

  int _measureSteps(List<double> desiredAccelData) {
    const threshold = 0.09;
    var steps = 0;
    var countSteps = true;
    
    for (var p in desiredAccelData) {
      if(p >= threshold && countSteps) {
        steps++;
        countSteps = false;
      }else if(p < 0 && !countSteps) {
        countSteps = true;
      }
    }
    return steps;
  }

  double _measureDistance(int steps, double userStrideLength) {
    return steps * userStrideLength;
  }
}
