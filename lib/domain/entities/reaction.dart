class Reaction {
  String uid;
  int type;
  String username;
  String name;
  String avatarUrl;
  DateTime createdDate;
  bool isFollowing;

  Reaction({
    required this.uid,
    required this.type,
    required this.username,
    required this.name,
    required this.avatarUrl,
    required this.createdDate,
    required this.isFollowing,
  });

  factory Reaction.empty() {
    return Reaction(uid: "", type: 0, username: "", name: "", avatarUrl: "", createdDate: DateTime.now(), isFollowing: false);
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "type": type,
      "username": username,
      "name": name,
      "avatarUrl": avatarUrl,
      "createdDate": createdDate.millisecondsSinceEpoch,
    };
  }

  factory Reaction.fromMap(Map<String, dynamic> map) {
    return Reaction(
      uid: map["uid"],
      type: 0,
      username: map["username"],
      name: map["name"],
      avatarUrl: map["avatarUrl"],
      createdDate: DateTime.now(), 
      isFollowing: map["isFollowing"],
    );
  }

  @override
  String toString() {
    return "Reaction{uid: $uid, type: $type, username: $username, name: $name, avatarUrl: $avatarUrl, createdDate: $createdDate}";
  }
}