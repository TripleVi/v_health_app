class Friend {
  String uid;
  String username;
  String firstName;
  String lastName;
  String avatarUrl;
  bool isFollowing;
  int mutual;

  Friend({
    required this.uid, 
    required this.username,
    required this.firstName, 
    required this.lastName, 
    required this.avatarUrl,
    required this.isFollowing,
    required this.mutual,
  });

  factory Friend.fromMap(Map<String, dynamic> map) {
    return Friend(uid: map["uid"], username: map["username"], firstName: map["firstName"], lastName: map["lastName"], avatarUrl: map["avatarUrl"], isFollowing: map["isFollowing"], mutual: map["mutual"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
    };
  }

  @override
  String toString() {
    return "{uid: $uid, username: $username, firstName: $firstName, lastName: $lastName, avatarUrl: $avatarUrl, isFollowing: $isFollowing, mutual: $mutual}";
  }
}