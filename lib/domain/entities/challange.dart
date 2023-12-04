import 'base_entity.dart';
import 'user.dart';

class Challenge extends BaseEntity {
  String title;
  String description;
  DateTime? createdAt;
  DateTime? startDate;
  DateTime? endDate;
  String targetType;
  double target;
  // String imageUrl;
  // User host;
  List<User> members;

  Challenge({
    super.id,
    required this.title,
    required this.description,
    this.startDate,
    this.endDate,
    required this.targetType,
    required this.target,
    this.members = const [], 
  });

  factory Challenge.fromFirestore(Map<String, dynamic> map) {
    return Challenge(
      id: map["challengeId"],
      title: map["title"], 
      description: map["description"],
      targetType: map["targetType"], 
      target: map["target"],
    );
  } 

  Map<String, dynamic> toFirestore() {
    return {
      "challengeId": id,
      "title": title,
      "description": description,
      "createdAt": createdAt,
      "startDate": startDate,
      "endDate": endDate,
      "targetType": targetType,
      "target": target,
    };
  }
}