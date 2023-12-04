enum Metrics {
  speed,
  distance,
  calories, 
  pace,
}

extension MetricsExtension on Metrics {
  String get unit {
    switch (this) {
      case Metrics.speed:
        return "km/h";
      case Metrics.distance:
        return "km";
      case Metrics.calories:
        return "cal";
      case Metrics.pace:
        return "/km";
      default:
        return "";
    }
  }
}