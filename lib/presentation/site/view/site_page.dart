import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enum/bottom_navbar.dart';
import '../../../core/resources/colors.dart';
import '../../../core/utilities/constants.dart';
import '../../activity_tracking/views/tracking_page.dart';
import '../../feed/view/feed_page.dart';
import '../../group/view/group_page.dart';
import '../../profile/view/profile_page.dart';
import '../../views/statistics/daily_stats.dart';
import '../bloc/site_bloc.dart';

class SitePage extends StatelessWidget {
  const SitePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SiteBloc>(
      create: (context) => SiteBloc(),
      child: const SiteView(),
    );
  }
}

class SiteView extends StatelessWidget {
  static const Map<TabType, Widget> _pages = {
    TabType.home: DailyStats(),
    TabType.feed: FeedPage(),
    TabType.tracking: TrackingPage(),
    TabType.group: GroupPage(),
    TabType.profile: ProfilePage(),
  };

  const SiteView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SiteBloc, SiteState>(
      builder: (context, state) {
        const iconSize = 24;
        return Scaffold(
          body: Stack(
            children: state.currentTabs.map((tab) => Offstage(
              offstage: tab != state.currentTab,
              child: _pages[tab]
            )).toList(growable: false)
          ),
          bottomNavigationBar: Visibility(
            maintainState: true,
            visible: state.navBarVisible,
            child: BottomNavigationBar(
              iconSize: iconSize * 1.0,
              showUnselectedLabels: false,
              showSelectedLabels: false,
              fixedColor: Constants.primaryColor,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home_filled),
                  label: TabType.home.stringValue,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.feed_rounded),
                  label: TabType.feed.stringValue,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.radio_button_checked_rounded),
                  label: TabType.tracking.stringValue,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.groups_rounded),
                  label: TabType.group.stringValue,
                ),
                BottomNavigationBarItem(
                  icon: CircleAvatar(
                    radius: iconSize / 2,
                    backgroundColor: AppColor.backgroundColor,
                    backgroundImage: Image.asset(
                      "assets/images/avatar.jpg",
                      cacheWidth: iconSize,
                      cacheHeight: iconSize,
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.contain,
                      isAntiAlias: true,
                    ).image,
                    foregroundImage: state.avatarUrl == null 
                        ? null 
                        : CachedNetworkImageProvider(
                            state.avatarUrl!, 
                            maxWidth: iconSize, 
                            maxHeight: iconSize,
                          ),
                  ),
                  label: TabType.profile.stringValue,
                ),
              ],
              currentIndex: state.currentTab.index,
              onTap: (index) => context.read<SiteBloc>()
                  .add(NavbarTabSelected(TabType.values[index])),
            ),
          ),
        );
      },
    );
  }
}
