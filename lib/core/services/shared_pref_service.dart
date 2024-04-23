import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/user.dart';
import '../enum/user_enum.dart';

class SharedPrefService {
  SharedPrefService();

  static Future<User> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final user = User.empty()
    ..uid = prefs.getString("uid")!
    ..email = prefs.getString("email")!
    ..username = prefs.getString("username")!
    ..gender = UserGender.values[prefs.getInt("gender")!]
    // ..height = prefs.getInt("height")!
    ..weight = prefs.getDouble("weight")!
    ..avatarUrl = prefs.getString("avatarUrl")!;
    return user;
  }

  static Future<void> createCurrentUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("uid", user.uid);
    await prefs.setString("email", user.email);
    await prefs.setString("username", user.username);
    await prefs.setInt("gender", user.gender.index);
    await prefs.setInt("height", user.height);
    await prefs.setDouble("weight", user.weight);
    await prefs.setString("avatarUrl", user.avatarUrl);
  }

  static Future<double> getUserStrideLength() async {
    final user = await getCurrentUser();
    // m
    //? 0: male, 1: female
    const multipliers = [0.415, 0.413];
    // return user.gender.isOther
    //     ? multipliers.sum / multipliers.length * user.height
    //     : multipliers[user.gender.index] * user.height;
    return multipliers[user.gender.index] * user.height;
  }

  static Future<void> removeCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("uid");
    await prefs.remove("email");
    await prefs.remove("username");
    await prefs.remove("gender");
    await prefs.remove("height");
    await prefs.remove("weight");
    await prefs.remove("avatarUrl");
  }
}