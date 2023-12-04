enum TabType { home, feed, tracking, group, profile }

extension TabTypeExtension on TabType {
  bool get isHome => this == TabType.home;
  bool get isFeed => this == TabType.feed;
  bool get isTracking => this == TabType.tracking;
  bool get isGroup => this == TabType.group;
  bool get isProfile => this == TabType.profile;

  String get stringValue {
    switch (this) {
      case TabType.home:
        return "Home";
      case TabType.feed:
        return "Feed";
      case TabType.tracking:
        return "Tracking";
      case TabType.group:
        return "Group";
      case TabType.profile:
      default:
        return "Profile";
    }
  }
}