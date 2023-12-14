import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/enum/bottom_navbar.dart';
import '../../../main.dart';

part 'site_event.dart';
part 'site_state.dart';

class SiteBloc extends Bloc<SiteEvent, SiteState> {
  SiteBloc() : super(const SiteState()) {
    on<UserFetched>(_onUserFetched);
    on<NavbarTabSelected>(_onNavbarTabSelected);
    on<PreviousTapShown>(_onPreviousTabShown);
    on<NavbarShown>(_onNavbarShown);
    on<NavbarHidden>(_onNavbarHidden);
    // registerNotification();
    add(UserFetched());

    backgroundService.startService();
  }

  Future<void> _onUserFetched(UserFetched event, Emitter<SiteState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final avatarUrl = prefs.getString("avatarUrl")!;
    emit(state.copyWith(avatarUrl: avatarUrl));
  }

  void _onNavbarTabSelected(NavbarTabSelected event, Emitter<SiteState> emit) {
    var currentTabs = state.currentTabs;
    if(state.currentTabs.length < TabType.values.length 
        && !state.currentTabs.contains(event.selectedTab)) {
      currentTabs = state.currentTabs.toList()
      ..add(event.selectedTab);
    }
    emit(state.copyWith(
      previousTab: state.currentTab, 
      currentTab: event.selectedTab, 
      currentTabs: currentTabs,
      navBarVisible: !event.selectedTab.isTracking,
    ));
  }

  void _onNavbarHidden(NavbarHidden event, Emitter<SiteState> emit) {
    emit(state.copyWith(navBarVisible: false));
  }

  void _onNavbarShown(NavbarShown event, Emitter<SiteState> emit) {
    emit(state.copyWith(navBarVisible: true));
  }

  void _onPreviousTabShown(
    PreviousTapShown event, 
    Emitter<SiteState> emit,
  ) {
    emit(state.copyWith(
      currentTab: state.previousTab, 
      navBarVisible: true,
    ));
  }
}
