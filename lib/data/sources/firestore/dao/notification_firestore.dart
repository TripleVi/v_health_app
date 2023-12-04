// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../../../../domain/entities/user_notification.dart';

// class NotificationFirestore {
//   Future<int> countUncheckedNotifications(String userId) async {
//     final result = await FirebaseFirestore.instance
//       .collection("users/$userId/notifications")
//       .where("isChecked", isEqualTo: false)
//       .count()
//       .get();
//     return result.count;
//   }

//   Stream<List<UserNotification>> getNotifications(String userId) {
//     return FirebaseFirestore.instance
//       .collection("users/$userId/notifications")
//       .orderBy("dateTime", descending: true)
//       .snapshots()
//       .map((querySnap) => querySnap.docs.map((doc) => 
//           UserNotification.fromFirestore(doc.id, doc.data())).toList());
//   }

//   // Future<bool> existsRequest(UserNotification request) async {
//   //   final snapshots = await FirebaseFirestore.instance
//   //       .collection(UserFields.container)
//   //       .where("from_user", isEqualTo: request.sender)
//   //       .where("to_user", isEqualTo: request.receiver)
//   //       .get();
//   //   if (snapshots.docs.isNotEmpty) {
//   //     return true;
//   //   }
//   //   return false;
//   // }

//   // Future<List<UserNotification>> fetchUserNotifications() async {
//   //   List<UserNotification> requests = [];
//   //   User? user = await _userDao.getUser();
//   //   final snapshots = await FirebaseFirestore.instance
//   //       .collection(NotificationFields.container)
//   //       .where(NotificationFields.sender, isEqualTo: user.id)
//   //       .get();

//   //   for (var snapshot in snapshots.docs) {
//   //     requests.add(UserNotification.fromDocumentSnapshot(snapshot));
//   //   }

//   //   return requests;
//   // }
// }