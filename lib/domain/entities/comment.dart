import 'base_entity.dart';
import 'user.dart';


class Comment extends BaseEntity {
  String content;
  DateTime createdDate;
  String path;
  User author;
  Comment? replyTo;

  Comment({
    super.id,
    required this.content,
    required this.createdDate,
    required this.path,
    User? author,
    this.replyTo,
  }) : author = author ?? User.empty();

  factory Comment.empty() {
    return Comment(content: "", createdDate: DateTime.now(), path: "", author: User.empty());
  }

  Map<String, dynamic> toMap() {
    return {
      "cid": id,
      "content": content,
      "createdDate": createdDate.millisecondsSinceEpoch,
      "path": path,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map["cid"],
      content: map["content"],
      createdDate: DateTime.fromMillisecondsSinceEpoch(map["createdDate"]),
      path: map["path"],
    );
  }

  @override
  String toString() {
    return "Comment{id: $id, content: $content, createdDate: $createdDate, path: $path, author: $author, replyTo: $replyTo}";
  }
}