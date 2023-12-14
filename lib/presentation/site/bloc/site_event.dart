part of 'site_bloc.dart';

@immutable
sealed class SiteEvent {}

class UserFetched extends SiteEvent {}

class NavbarTabSelected extends SiteEvent {
  final TabType selectedTab;

  NavbarTabSelected(this.selectedTab);
}

class PreviousTapShown extends SiteEvent {}

class NavbarHidden extends SiteEvent {}

class NavbarShown extends SiteEvent {}