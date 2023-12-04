// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:timeago/timeago.dart' as timeago;

// import '../../../core/resources/colors.dart';
// import '../../../core/resources/style.dart';
// import '../../../core/utilities/constants.dart';
// import '../../widgets/appBar.dart';
// import '../../widgets/loading_indicator.dart';
// import '../../widgets/text.dart';
// import '../bloc/notification_bloc.dart';

// class NotificationsPage extends StatelessWidget {
//   const NotificationsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<NotificationBloc>(
//       create: (context) => NotificationBloc(),
//       child: const NotificationsView(),
//     );
//   }
// }

// class NotificationsView extends StatelessWidget {
//   const NotificationsView({super.key});

//   Widget internetConnection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Center(
//           child: SizedBox(
//             width: 200,
//             child: TextTypes.paragraph(
//               content:
//                   'Device must be connected to the internet to use this feature',
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 8.0),
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Constants.primaryColor
//             ),
//             onPressed: () {
//               // ConnectionService.instance.isConnected()
//             },
//             child: const Icon(Icons.refresh),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar.get(title: "Notifications"),
//       body: Container(
//         decoration: BoxDecoration(
//           border: Border(top: BorderSide(color: AppColor.onBackgroundColor)),
//         ),
//         child: BlocBuilder<NotificationBloc, NotificationState>(
//           builder: (context, state) {
//             if(state is NotificationLoading) {
//               return const AppLoadingIndicator();
//             }
//             if(state is NotificationLoaded) {
//               return _notificationListView(state);
//             }
//             final errorMsg = (state as NotificationError).message;
//             return Center(
//               child: Text(errorMsg, style: AppStyle.paragraph()),
//             );
//           },
//         ),
//       )
//     );
//   }

//   Widget _notificationListView(NotificationLoaded state) {
//     final notifications = state.notifications;
//     if(notifications.isEmpty) {
//       return Center(
//         child: SizedBox(
//           width: 270.0,
//           child: Text(
//             "Your notifications are currently empty at the moment",
//             textAlign: TextAlign.center,
//             style: AppStyle.paragraph(),
//           ),
//         ),
//       );
//     }
//     const avatarSize = 40;
//     return ListView.builder(
//       padding: const EdgeInsets.all(8.0),
//       itemCount: notifications.length,
//       itemBuilder: ((context, index) {
//         final notification = notifications[index];
//         return GestureDetector(
//           onTap: () {
            
//           },
//           child: Card(
//             color: notification.isChecked ? null : Colors.blue.shade100,
//             margin: const EdgeInsets.symmetric(vertical: 8.0),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12.0),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 8.0,
//                 vertical: 12.0,
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CircleAvatar(
//                     radius: avatarSize/2,
//                     backgroundColor: AppColor.backgroundColor,
//                     backgroundImage: Image.asset(
//                       "assets/images/avatar.jpg",
//                       cacheWidth: avatarSize,
//                       cacheHeight: avatarSize,
//                       filterQuality: FilterQuality.high,
//                       isAntiAlias: true,
//                       fit: BoxFit.contain,
//                     ).image,
//                     foregroundImage: notification.imageUrl.isEmpty
//                         ? null
//                         : Image.network(
//                             notification.imageUrl,
//                             cacheWidth: avatarSize,
//                             cacheHeight: avatarSize,
//                             filterQuality: FilterQuality.high,
//                             isAntiAlias: true,
//                             fit: BoxFit.contain,
//                           ).image,
//                   ),
//                   const SizedBox(width: 8.0),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(notification.content,
//                           style: AppStyle.heading_2(fontSize: 14.0),
//                         ),
//                         Text(timeago.format(notification.dateTime, locale: "en"),
//                           style: AppStyle.label(fontSize: 12.0),
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ),
//         );
//       }),
//     );
//   }
// }
