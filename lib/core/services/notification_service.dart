// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:get_it/get_it.dart';

// import '../../data/repositories/user_repo.dart';
// import '../../firebase_options.dart';

// @pragma('vm:entry-point')
// Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   print('aHandling a background message ${message.messageId}');
// }

// Future<void> registerNotification() async {
//   final messaging = FirebaseMessaging.instance;
//   final settings = await messaging.requestPermission(
//     alert: true,
//     announcement: false,
//     badge: true,
//     carPlay: false,
//     criticalAlert: false,
//     provisional: false,
//     sound: true,
//   );
//   print("Notification permission: ${settings.authorizationStatus}");
//   final fcmToken = await messaging.getToken();
//   final user = await GetIt.instance<UserRepo>().getUserSession();
//   print("FCM token: $fcmToken");
//   if(settings.authorizationStatus == AuthorizationStatus.authorized
//     || settings.authorizationStatus == AuthorizationStatus.provisional) {
//     final map = <String, dynamic>{
//       "timestamp": FieldValue.serverTimestamp(),
//     };
//     FirebaseFirestore.instance
//       .collection("users/${user.id}/pushTokens")
//       .doc(fcmToken)
//       .set(map);
//   }else {
//     FirebaseFirestore.instance
//       .collection("users/${user.id}/pushTokens")
//       .doc(fcmToken)
//       .delete();
//   }

//   FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);

//   messaging.onTokenRefresh.listen((fcmToken) {
    
//   });

//   FirebaseMessaging.onMessage.listen((message) {
//     print('Got a message whilst in the foreground!');
//     print('Message data: ${message.data}');
    
//     if (message.notification != null) {
//       print('Message also contained a notification: ${message.notification}');
//     }
//   });
// }