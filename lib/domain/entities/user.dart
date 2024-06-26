import "../../core/enum/user_enum.dart";

class User {
  String uid;
  String username;
  String password;
  String name;
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
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    required this.weight,
    required this.height,
    required this.avatarUrl,
  });

  double get strideLength {
    //? 0: male, 1: female
    const multipliers = [0.415, 0.413];
    // return user.gender.isOther
    //     ? multipliers.sum / multipliers.length * user.height
    //     : multipliers[user.gender.index] * user.height;
    //? convert cm to m 
    return multipliers[gender.index] * height / 100;
  }

  factory User.empty() {
    return User(uid: "", username: "", password: "", name: "", dateOfBirth: "", gender: UserGender.male, weight: 0.0, height: 170, avatarUrl: "", email: "");
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(uid: map["uid"], username: map["username"], password: map["password"] ?? "", email: map["email"], name: map["name"], dateOfBirth: map["dateOfBirth"], gender: UserGender.values[map["gender"]], weight: map["weight"]*1.0, height: map["height"], avatarUrl: map["avatarUrl"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid, "username": username, "email": email, "name": name, "dateOfBirth": dateOfBirth, "gender": gender.index, "weight": weight, "height": height, "avatarUrl": avatarUrl,
    };
  }

  @override
  String toString() {
    return "User{id: $uid, name: $name, dateOfBirth: $dateOfBirth, gender: ${gender.stringValue}, username: $username, password: $password, weight: $weight, height: $height avatarUrl: $avatarUrl, email: $email}";
  }
}
