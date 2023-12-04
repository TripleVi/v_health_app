import 'base_entity.dart';
import 'user.dart';


class Comment extends BaseEntity {
  String content;
  DateTime createdDate;
  User author;
  Comment? parent;

  Comment({
    super.id,
    required this.content,
    required this.createdDate,
    User? author,
    this.parent,
  }) : author = author ?? User.empty();

  factory Comment.empty() {
    return Comment(content: "", createdDate: DateTime.now(), author: User.empty());
  }

  Map<String, dynamic> toMap() {
    return {
      "cid": id,
      "content": content,
      "createdDate": createdDate.millisecondsSinceEpoch,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map["cid"],
      content: map["content"],
      createdDate: DateTime.fromMillisecondsSinceEpoch(map["createdDate"]),
    );
  }

  @override
  String toString() {
    return "Comment{id: $id, content: $content, createdDate: $createdDate, author: $author, parent: $parent}";
  }
}