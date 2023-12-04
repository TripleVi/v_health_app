import 'package:iirjdart/butterworth.dart';

class SignalFilterService {
  SignalFilterService();

  static List<double> lowPassFilter({
    required List<double> timeSeries, 
    required double samplingRate, 
    required double cutoffFreq,
  }) {
    final butterworth = Butterworth()
    ..lowPass(2, samplingRate, cutoffFreq);
    return timeSeries
        .map((p) => butterworth.filter(p))
        .toList(growable: false);
  }

  static List<double> highPassFilter({
    required List<double> timeSeries, 
    required double samplingRate, 
    required double cutoffFreq,
  }) {
    final butterworth = Butterworth()
    ..highPass(2, samplingRate, cutoffFreq);
    return timeSeries
        .map((p) => butterworth.filter(p))
        .toList(growable: false);
  }
}