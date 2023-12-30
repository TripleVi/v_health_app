import 'package:matrix2d/matrix2d.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/user.dart';
import '../enum/user_enum.dart';

class UserService {
  UserService();

  static Future<User> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final user = User.empty()
    ..uid = prefs.getString("uid")!
    ..email = prefs.getString("email")!
    ..username = prefs.getString("username")!
    ..gender = UserGender.values[prefs.getInt("gender")!]
    ..height = prefs.getDouble("height")!
    ..weight = prefs.getDouble("weight")!
    ..avatarUrl = prefs.getString("avatarUrl")!;
    return user;
  }

  static Future<double> getUserStrideLength() async {
    final user = await getCurrentUser();
    // m
    //? 0: male, 1: female
    const multipliers = [0.415, 0.413];
    // const averages = [78.0, 70.0];
    return user.gender.isOther
        ? multipliers.sum / multipliers.length * user.height
        : multipliers[user.gender.index] * user.height;
  }
}