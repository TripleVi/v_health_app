import 'package:matrix2d/matrix2d.dart';
import 'package:v_health/core/utilities/utils.dart';
import 'package:v_health/domain/entities/daily_report.dart';

import '../../data/repositories/daily_goal_repo.dart';
import '../../data/repositories/hourly_report_repo.dart';
import '../../domain/entities/report.dart';
import '../../data/repositories/daily_report_repo.dart';
import '../utilities/constants.dart';
import 'signal_filter_service.dart';
import 'shared_pref_service.dart';

class AccelerationService {
  AccelerationService();

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
    final strideLength = await SharedPrefService.getUserStrideLength();
    final distance = _measureDistance(steps, strideLength);
    final calories = (steps * 0.025).round();
    final today = MyUtils.getDateAtMidnight(date);
    final dailyRepo = DailyReportRepo();
    final hourlyRepo = HourlyReportRepo();
    var dReport = await dailyRepo.fetchDailyReport(today);
    if(dReport.id == Constants.newId) {
      final goalRepo = DailyGoalRepo();
      final goal = await goalRepo.fetchLatestGoal();
      final newReport = DailyReport.empty()
      ..steps = steps
      ..distance = distance
      ..calories = calories
      ..goal = goal;
      newReport.id = await dailyRepo.createDailyReport(newReport);
      dReport = newReport;
    }else {
      dReport
      ..steps += steps
      ..calories += calories
      ..distance += distance;
      await dailyRepo.updateDailyReport(dReport);
    }
    final utcHour = date.toUtc().hour;
    final hReport = await hourlyRepo.fetchReport(dReport.id, utcHour);
    if(hReport.id == Constants.newId) {
      final newReport = Report.empty()
      ..hour = utcHour
      ..steps = steps
      ..distance = distance
      ..calories = calories.round()
      ..day.id = dReport.id;
      await hourlyRepo.createReport(newReport);
    }else {
      hReport.distance += distance;
      hReport.steps += steps;
      await hourlyRepo.updateReport(hReport);
    }
  }

  Future<Map<String, dynamic>> analyze(
    List<List<double>> rawAccelData, double samplingRate
  ) async {
    final desiredData = _process(rawAccelData, samplingRate);
    final steps = _measureSteps(desiredData);
    final strideLength = await SharedPrefService.getUserStrideLength();
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
