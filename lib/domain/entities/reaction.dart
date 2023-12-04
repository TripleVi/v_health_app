class Reaction {
  String userId;
  int type;
  String firstName;
  String lastName;
  String username;
  String? avatarUrl;
  DateTime? createdAt;

  Reaction({
    required this.userId,
    required this.type,
    required this.firstName,
    required this.lastName,
    required this.username,
    this.avatarUrl,
  });

  // factory Reaction.fromFirestore(Map<String, dynamic> map) {
  //   final reaction = Reaction(
  //     userId: map["userId"],
  //     type: map["type"],
  //     firstName: map["firstName"],
  //     lastName: map["lastName"],
  //     username: map["username"],
  //     avatarUrl: map["avatarUrl"],
  //   )
  //   ..createdAt = (map["createdAt"]! as Timestamp).toDate().toLocal();
  //   return reaction;
  // }

  // Map<String,dynamic> toFirestore() {
  //   return {
  //     "userId": userId,
  //     "type": type,
  //     "firstName": firstName,
  //     "lastName": lastName,
  //     "username": username,
  //     "avatarUrl": avatarUrl,
  //     "createdAt": FieldValue.serverTimestamp(),
  //   };
  // }
}