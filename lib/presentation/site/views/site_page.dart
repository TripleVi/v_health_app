import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../core/enum/bottom_navbar.dart";
import "../../../core/resources/style.dart";
import "../../../core/utilities/constants.dart";
import "../../activity_tracking/views/tracking_page.dart";
import "../../feed/views/feed_page.dart";
import "../../notification/view/notification_page.dart";
import "../../profile/view/profile_page.dart";
import "../../statistics/views/statistics_page.dart";
import "../bloc/site_bloc.dart";

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

// _searchButton(BuildContext context) {
//     return Stack(
//       alignment: AlignmentDirectional.center,
//       children: [
//         GestureDetector(
//           onTap: () {
            
//           },
//           child: const Icon(Icons.search_rounded, size: 28.0),
//         ),
//         Positioned(
//           left: 24.0,
//           top: 24.0,
//           child: CircleAvatar(
//             backgroundColor: Colors.red,
//             minRadius: 8.0,
//             child: Padding(
//               padding: const EdgeInsets.all(4.0),
//               child: Text("12", 
//                 style: AppStyle.caption2(
//                   fontSize: 12.0,
//                   color: Colors.white,
//                   height: 1.0,
//                 )
//               ),
//             ),
//           ),
//         )
//       ],
//     );
//   }

class SiteView extends StatelessWidget {
  static const Map<TabType, Widget> _pages = {
    TabType.home: FeedPage(),
    TabType.statistics: StatisticsPage(),
    TabType.tracking: TrackingPage(),
    TabType.notification: NotificationPage(),
    TabType.profile: ProfilePage(),
    // TabType.group: GroupPage(),
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
                  icon: const Icon(Icons.auto_graph_sharp),
                  label: TabType.statistics.stringValue,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.radio_button_checked_rounded),
                  label: TabType.tracking.stringValue,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.notifications_rounded),
                  label: TabType.notification.stringValue,
                ),
                BottomNavigationBarItem(
                  icon: CircleAvatar(
                    radius: iconSize / 2,
                    backgroundColor: AppStyle.surfaceColor,
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
