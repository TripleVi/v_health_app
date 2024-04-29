import "../../core/enum/social.dart";
import "activity_record.dart";
import "base_entity.dart";
import "reaction.dart";
import "user.dart";

class Post extends BaseEntity {
  String title;
  String content;
  DateTime createdDate;
  PostPrivacy privacy;
  double latitude;
  double longitude;
  String address;
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
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.mapUrl,
    this.reactions = const [],
    User? author,
    ActivityRecord? record,
  }) 
  : author = author ?? User.empty(), 
    record = record ?? ActivityRecord.empty();

  factory Post.empty() {
    return Post(title: "", content: "", createdDate: DateTime.now(), privacy: PostPrivacy.public, latitude: 0.0, longitude: 0.0, address: "", mapUrl: "");
  }

  Map<String, dynamic> toMap() {
    final txtDate = createdDate.toIso8601String();
    final timezone = createdDate.timeZoneName;
    return {
      "pid": id,
      "title": title,
      "content": content,
      "createdDate": "$txtDate$timezone",
      "privacy": privacy.numericValue,
      "latitude": latitude,
      "longitude": longitude,
      "address": address,
      "mapUrl": mapUrl,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    final date = DateTime.parse(map["createdDate"]).toLocal();
    final privacy = PostPrivacy.values
        .firstWhere((e) => e.numericValue == map["privacy"]);
    return Post(
      id: map["pid"],
      title: map["title"], 
      content: map["content"], 
      createdDate: date, 
      privacy: privacy,
      latitude: map["latitude"] * 1.0,
      longitude: map["longitude"] * 1.0,
      address: map["address"],
      mapUrl: map["mapUrl"],
    );
  }

  @override
  String toString() {
    return "Post{id: $id, title: $title, content: $content, createdDate: $createdDate, privacy: $privacy, latitude: $latitude, longitude: $longitude, address: $address, author: $author}";
  }
}