// import '../../core/utilities/utils.dart';
// import '../../data/sources/table_attributes.dart';
// import 'base_entity.dart';

// class UserNotification extends BaseEntity {
//   String type;
//   String sender;
//   String receiver;
//   DateTime dateTime;
//   int code;
//   int status;
//   String content;
//   String imageUrl;
//   bool isChecked;

//   UserNotification({
//     super.id, 
//     required this.type,
//     required this.sender, 
//     required this.receiver, 
//     required this.dateTime,
//     this.code = 0, 
//     this.status = 0,
//     required this.content, 
//     required this.imageUrl, 
//     required this.isChecked,
//   });

//   factory UserNotification.fromFirestore(String docId, Map<String, dynamic> map) {
//     return UserNotification(
//       id: docId,
//       type: map[NotificationFields.type],
//       sender: map[NotificationFields.sender],
//       receiver: map[NotificationFields.receiver],
//       dateTime: MyUtils.getLocalDateTime(map[NotificationFields.dateTime]),
//       code: map[NotificationFields.code],
//       status: map[NotificationFields.status],
//       content: map[NotificationFields.content],
//       imageUrl: map[NotificationFields.imageUrl],
//       isChecked: map[NotificationFields.isChecked],
//     );
//   }

//   @override
//   String toString() {
//     return "{id: $id, type: $type, sender: $sender, receiver: $receiver, dateTime: $dateTime, code: $code, sta: $status, calories: $content, isChecked: $isChecked}";
//   }
// }
