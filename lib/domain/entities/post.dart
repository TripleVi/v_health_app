import '../../core/enum/social.dart';
import 'activity_record.dart';
import 'base_entity.dart';
import 'reaction.dart';
import 'user.dart';

class Post extends BaseEntity {
  String title;
  String content;
  DateTime createdDate;
  PostPrivacy privacy;
  double? latitude;
  double? longitude;
  String mapUrl;
  ActivityRecord record;
  List<Reaction> reactions;
  User author;

  Post({
    super.id,
    required this.title,
    required this.content,
    required this.createdDate,
    required this.privacy,
    this.latitude,
    this.longitude,
    required this.mapUrl,
    this.reactions = const [],
    User? author,
    ActivityRecord? record,
  }) 
  : author = author ?? User.empty(), 
    record = record ?? ActivityRecord.empty();

  factory Post.empty() {
    return Post(title: "", content: "", createdDate: DateTime.now(), privacy: PostPrivacy.public, mapUrl: "");
  }

  Map<String, dynamic> toMap() {
    return {
      "pid": id,
      "title": title,
      "content": content,
      "createdDate": createdDate.millisecondsSinceEpoch,
      "privacy": privacy.numericValue,
      "latitude": latitude,
      "longitude": longitude,
      "mapUrl": mapUrl,
    };
  }

  // factory Post.fromSqlite(Map<String, dynamic> map) {
  //   final post = Post(
  //     id: map[PostFields.id],
  //     title: map[PostFields.title],
  //     content: map[PostFields.content],
  //     privacy: PostPrivacy.values[map[PostFields.privacy]],
  //     recordId: map[PostFields.recordId],
  //   )
  //   .._createdDate = MyUtils.getLocalDateTime(map[PostFields.createdDate]);
  //   return post;
  // }

  // Map<String, dynamic> toSqlite() {
  //   return {
  //     PostFields.id: id,
  //     PostFields.title: title,
  //     PostFields.content: content,
  //     PostFields.privacy: privacy.index,
  //     PostFields.createdDate: createdDate!.millisecondsSinceEpoch,
  //     PostFields.recordId: recordId,
  //   };
  // }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map["pid"],
      title: map["title"], 
      content: map["content"], 
      createdDate: DateTime.fromMillisecondsSinceEpoch(map["createdDate"]), 
      privacy: PostPrivacy.values.firstWhere((e) => e.numericValue == map["privacy"]),
      latitude: map["latitude"] * 1.0,
      longitude: map["longitude"] * 1.0,
      mapUrl: map["mapUrl"],
    );
  }

  @override
  String toString() {
    return "Post{id: $id, title: $title, content: $content, createdDate: $createdDate, privacy: $privacy, latitude: $latitude, longitude: $longitude, author: $author}";
  }
}