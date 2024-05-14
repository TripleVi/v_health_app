class People {
  String uid;
  String username;
  String name;
  String avatarUrl;
  bool isFollowing;
  int mutual;

  People({
    required this.uid, 
    required this.username,
    required this.name,
    required this.avatarUrl,
    required this.isFollowing,
    required this.mutual,
  });

  factory People.empty() {
    return People(uid: "", username: "", name: "", avatarUrl: "", isFollowing: false, mutual: 0);
  }

  factory People.fromMap(Map<String, dynamic> map) {
    return People(uid: map["uid"], username: map["username"], name: map["name"], avatarUrl: map["avatarUrl"], isFollowing: map["isFollowing"], mutual: map["mutual"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
    };
  }

  @override
  String toString() {
    return "{uid: $uid, username: $username, name: $name, avatarUrl: $avatarUrl, isFollowing: $isFollowing, mutual: $mutual}";
  }
}