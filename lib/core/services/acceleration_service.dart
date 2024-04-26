import "package:matrix2d/matrix2d.dart";

import "../../data/repositories/daily_goal_repo.dart";
import "../../data/repositories/hourly_report_repo.dart";
import "../../domain/entities/daily_report.dart";
import "../../domain/entities/report.dart";
import "../../data/repositories/daily_report_repo.dart";
import "../utilities/constants.dart";
import "../utilities/utils.dart";
import "signal_filter_service.dart";
import "shared_pref_service.dart";

class AccelerationService {
  AccelerationService();

  double getStrideByHeight(double height, int gender) {
    return gender == 1 ? height * 0.415 : height * 0.413;
  }

  double getRunningStrideByHeight(double height, int gender) {
    return gender == 1 ? height * 1.14 : height * 1.17;
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
    required DateTime date,
  }) async {
    if(rawAccelData.length < 50) return;
    final desiredData = _process(
        rawAccelData, rawAccelData.length/Constants.inactiveInterval);
    final [steps, activeTime] = _measureStepsAndActiveTime(
        Constants.inactiveInterval, desiredData);
    if(steps == 0) return;
    final user = await SharedPrefService.getCurrentUser();
    final distance = steps * user.strideLength;
    final calories = calculateCalories(activeTime, user.weight);
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
      ..activeTime = activeTime
      ..goal = goal;
      newReport.id = await dailyRepo.createDailyReport(newReport);
      dReport = newReport;
    }else {
      dReport
      ..steps += steps
      ..calories += calories
      ..distance += distance
      ..activeTime += activeTime;
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

  Future<Map<String, dynamic>> analyze(List<List<double>> rawAccelData) async {
    if(rawAccelData.length < 50) throw "Not enough data for analysis.";
    final desiredData = _process(
        rawAccelData, rawAccelData.length/Constants.activeInterval);
    final [steps, activeTime] = _measureStepsAndActiveTime(
        Constants.activeInterval, desiredData);
    final user = await SharedPrefService.getCurrentUser();
    final distance = steps * user.strideLength;
    final calories = calculateCalories(activeTime, user.weight);
    return {
      "steps": steps,
      "distance": distance,
      "calories": calories,
      "activeTime": activeTime,
      "speed": activeTime == 0 ? 0.0 : distance/activeTime,
    };
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

  List<int> _measureStepsAndActiveTime(int time, List<double> desiredData) {
    const threshold = 0.09;
    var steps = 0;
    var countSteps = true;
    var activeTime = 0.0;
    for (var i = 0; i < desiredData.length; i++) {
      if(desiredData[i] >= threshold && countSteps) {
        steps++;
        countSteps = false;
        int j = i;
        int k = i;
        while (desiredData[--j] >= 0) {}
        while (k < desiredData.length-1 && desiredData[++k] >= 0) {}
        while (k < desiredData.length-1 && desiredData[++k] <= 0) {}
        activeTime += (k - j) / (desiredData.length / time);
      }else if(desiredData[i] < 0 && !countSteps) {
        countSteps = true;
      }
    }
    return [steps, activeTime.ceil()];
  }

  double calculateCalories(int activeTime, double weight) {
    const walkingMET = 3.8;
    return activeTime * walkingMET * 3.5 * weight / (200 * 60);
  }
}
