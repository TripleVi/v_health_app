import '../../core/enum/user_enum.dart';

class User {
  String uid;
  String username;
  String password;
  String firstName;
  String lastName;
  String dateOfBirth;
  UserGender gender;
  double weight; // kilogram
  int height; // centimeter
  String avatarUrl;
  String email;

  User({
    required this.uid,
    required this.username,
    required this.password,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.weight,
    required this.height,
    required this.avatarUrl,
  });

  factory User.empty() {
    return User(uid: "", username: "", password: "", firstName: "", lastName: "", dateOfBirth: "", gender: UserGender.other, weight: 0.0, height: 170, avatarUrl: "", email: "");
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(uid: map["uid"], username: map["username"], password: map["password"] ?? "", email: map["email"], firstName: map["firstName"], lastName: map["lastName"], dateOfBirth: map["dateOfBirth"], gender: UserGender.values[map["gender"]], weight: map["weight"]*1.0, height: map["height"], avatarUrl: map["avatarUrl"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid, "username": username, "email": email, "firstName": firstName, "lastName": lastName, "dateOfBirth": dateOfBirth, "gender": gender.index, "weight": weight, "height": height, "avatarUrl": avatarUrl,
    };
  }

  @override
  String toString() {
    return "User{id: $uid, firstName: $firstName, lastName: $lastName, dateOfBirth: $dateOfBirth, gender: ${gender.stringValue}, username: $username, password: $password, weight: $weight, height: $height avatarUrl: $avatarUrl, email: $email}";
  }
}
