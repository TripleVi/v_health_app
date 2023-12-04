part of 'site_bloc.dart';

@immutable
final class SiteState {
  final String? avatarUrl;
  final bool navBarVisible;
  final TabType currentTab;
  final TabType previousTab;
  final List<TabType> currentTabs;

  const SiteState({
    this.avatarUrl,
    this.navBarVisible = true,
    this.currentTab = TabType.home,
    this.previousTab = TabType.home,
    this.currentTabs = const [TabType.home],
  });

  SiteState copyWith({
    String? avatarUrl,
    bool? navBarVisible,
    TabType? currentTab,
    TabType? previousTab,
    List<TabType>? currentTabs,

  }) {
    return SiteState(
      avatarUrl: avatarUrl ?? this.avatarUrl,
      navBarVisible: navBarVisible ?? this.navBarVisible,
      currentTab: currentTab ?? this.currentTab,
      previousTab: previousTab ?? this.previousTab,
      currentTabs: currentTabs ?? this.currentTabs,
    );
  }
}
