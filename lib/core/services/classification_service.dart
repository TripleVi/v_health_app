import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:matrix2d/matrix2d.dart';
import 'package:v_health/core/utilities/utils.dart';
import 'package:v_health/domain/entities/daily_steps.dart';

import '../../data/repositories/hourly_report_repo.dart';
import '../../domain/entities/report.dart';
import '../../data/repositories/daily_report_repo.dart';
import 'signal_filter_service.dart';
import 'user_service.dart';

class ClassificationService {
  ClassificationService();

  double getStrideByHeight(double height, int gender) {
    return gender == 1 ? height * 0.415 : height * 0.413;
  }

  double getRunningStrideByHeight(double height, int gender) {
    return gender == 1 ? height * 1.14 : height * 1.17;
  }

  double calculateCalories(int walk, int run, int climb_up, int climb_down) {
    return walk * 0.02 + run * 0.03 + climb_up * 0.04 + climb_down * 0.02;
  }

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

  Future<void> updateReports({
    required List<List<double>> rawAccelData, 
    required double samplingRate,
    required DateTime date,
  }) async {
    if(rawAccelData.length < 50) return;
    final desiredData = _process(rawAccelData, samplingRate);
    final steps = _measureSteps(desiredData);
    if(steps == 0) return;
    final strideLength = await UserService.getUserStrideLength();
    final distance = _measureDistance(steps, strideLength);
    final calories = (steps * 0.025).round();
    const stair = 0;
    final sqlDate = MyUtils.getDateAsSqlFormat(date);
    final hReport = await HourlyReportRepo.instance.fetchReport(sqlDate, date.hour);
    if(hReport == null) {
      final newReport = Report.empty()
      ..date = sqlDate
      ..hour = date.hour
      ..steps = steps
      ..distance = distance
      ..stair = stair
      ..calories = calories.round();
      await HourlyReportRepo.instance.createReport(newReport);
    }else {
      hReport.distance += distance;
      hReport.steps += steps;
      await HourlyReportRepo.instance.updateReport(hReport);
    }
    final dReport = await ReportService.instance.fetchDailyReport(sqlDate);
    if(dReport == null) {
      final newReport = DailySummary(sqlDate, steps, distance, stair, calories);
      await ReportService.instance.createDailyReport(newReport);
    }else {
      dReport
      ..steps += steps
      ..stair += stair
      ..calories += calories
      ..distance += distance;
      await ReportService.instance.updateDailyReport(dReport);
    }
  }

  Future<Map<String, dynamic>> classify(
    List<List<double>> rawAccelData, double samplingRate
  ) async {
    final desiredData = _process(rawAccelData, samplingRate);
    final steps = _measureSteps(desiredData);
    final strideLength = await UserService.getUserStrideLength();
    final distance = _measureDistance(steps, strideLength);
    final calories = (steps * 0.025).round();
    return {
      "steps": steps,
      "distance": distance,
      "calories": calories,
    };
  }

  List<Map<String, dynamic>> test(List<List<double>> rawAccelData, List<DateTime> timeFrames, double samplingRate) {
    final desiredData = _process(rawAccelData, samplingRate);
    final data = <Map<String, dynamic>>[];
    const threshold = 0.09;
    var steps = 0;
    var countSteps = true;
    int i = 0;
    for (var p in desiredData) {
      final map = <String, dynamic>{};
      map["accel"] = p;
      map["timeFrame"] = timeFrames[i];
      if(p >= threshold && countSteps) {
        steps++;
        countSteps = false;
        map["step"] = true;
      }else if(p < 0 && !countSteps) {
        countSteps = true;
        map["step"] = false;
      }else {
        map["step"] = false;
      }
      i++;
      data.add(map);
    }
    print("Total steps: $steps");
    return data;
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
