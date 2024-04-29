import 'base_entity.dart';

class UserNotification extends BaseEntity {
  String type;
  String sender;
  String receiver;
  DateTime dateTime;
  int code;
  int status;
  String content;
  String imageUrl;
  bool isChecked;

  UserNotification({
    super.id, 
    required this.type,
    required this.sender, 
    required this.receiver, 
    required this.dateTime,
    this.code = 0, 
    this.status = 0,
    required this.content, 
    required this.imageUrl, 
    required this.isChecked,
  });

  @override
  String toString() {
    return "{id: $id, type: $type, sender: $sender, receiver: $receiver, dateTime: $dateTime, code: $code, sta: $status, calories: $content, isChecked: $isChecked}";
  }
}
