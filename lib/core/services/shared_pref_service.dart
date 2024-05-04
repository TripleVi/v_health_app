import "package:shared_preferences/shared_preferences.dart";

import "../../domain/entities/user.dart";
import "../enum/user_enum.dart";

class SharedPrefService {
  SharedPrefService();

  static Future<User> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final user = User.empty()
    ..uid = prefs.getString("uid")!
    ..email = prefs.getString("email")!
    ..username = prefs.getString("username")!
    ..name = prefs.getString("name")!
    ..gender = UserGender.values[prefs.getInt("gender")!]
    ..dateOfBirth = prefs.getString("dateOfBirth")!
    ..height = prefs.getInt("height")!
    ..weight = prefs.getDouble("weight")!
    ..avatarUrl = prefs.getString("avatarUrl")!;
    return user;
  }

  static Future<void> createCurrentUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("uid", user.uid);
    await prefs.setString("email", user.email);
    await prefs.setString("username", user.username);
    await prefs.setString("name", user.name);
    await prefs.setInt("gender", user.gender.index);
    await prefs.setString("dateOfBirth", user.dateOfBirth);
    await prefs.setInt("height", user.height);
    await prefs.setDouble("weight", user.weight);
    await prefs.setString("avatarUrl", user.avatarUrl);
  }

  static Future<void> removeCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("uid");
    await prefs.remove("email");
    await prefs.remove("username");
    await prefs.remove("name");
    await prefs.remove("gender");
    await prefs.remove("dateOfBirth");
    await prefs.remove("height");
    await prefs.remove("weight");
    await prefs.remove("avatarUrl");
  }

  static Future<void> updateCurrentUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("username", user.username);
    await prefs.setString("name", user.name);
    await prefs.setInt("gender", user.gender.index);
    await prefs.setInt("height", user.height);
    await prefs.setDouble("weight", user.weight);
    await prefs.setString("avatarUrl", user.avatarUrl);
  }
}