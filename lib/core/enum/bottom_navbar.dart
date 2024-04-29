enum TabType { home, statistics, tracking, notification, profile }

extension TabTypeExtension on TabType {
  bool get isHome => this == TabType.home;
  bool get isStatistics => this == TabType.statistics;
  bool get isTracking => this == TabType.tracking;
  bool get isNotification => this == TabType.notification;
  bool get isProfile => this == TabType.profile;

  String get stringValue {
    switch (this) {
      case TabType.home:
        return "Home";
      case TabType.tracking:
        return "Tracking";
      case TabType.notification:
        return "Notification";
      case TabType.statistics:
        return "Statistics";
      case TabType.profile:
      default:
        return "Profile";
    }
  }
}