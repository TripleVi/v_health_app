class Reaction {
  String uid;
  int type;
  String firstName;
  String lastName;
  String username;
  String avatarUrl;
  DateTime createdDate;

  Reaction({
    required this.uid,
    required this.type,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.avatarUrl,
    required this.createdDate,
  });

  factory Reaction.empty() {
    return Reaction(uid: "", type: 0, username: "", firstName: "", lastName: "", avatarUrl: "", createdDate: DateTime.now());
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "type": type,
      "username": username,
      "firstName": firstName,
      "lastName": lastName,
      "avatarUrl": avatarUrl,
      "createdDate": createdDate.millisecondsSinceEpoch,
    };
  }

  factory Reaction.fromMap(Map<String, dynamic> map) {
    return Reaction(
      uid: map["uid"],
      type: 0, 
      username: map["username"], 
      firstName: map["firstName"],
      lastName: map["lastName"],
      avatarUrl: map["avatarUrl"],
      createdDate: DateTime.now(), 
    );
  }

  @override
  String toString() {
    return "Reaction{uid: $uid, type: $type, username: $username, firstName: $firstName, lastName: $lastName, avatarUrl: $avatarUrl, createdDate: $createdDate}";
  }
}