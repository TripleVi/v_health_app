import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix2d/matrix2d.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_health/core/enum/user_enum.dart';

import '../../../../core/services/location_service.dart';
import '../../../../core/services/sensor_service.dart';
import '../../../../data/sources/api/user_api.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  void togglePassword() {
    emit(state.copyWith(passwordVisible: !state.passwordVisible));
  }

  Future<void> submitLoginForm(String account, String password) async {
    print("started");
    LocationService().locationUpdates(5).listen((p) {
      print(p.toJson());
      
    });
    return;
    try {
      emit(state.copyWith(isProcessing: true));
      final isEmail = account.contains('@');
      var email = account;
      final userService = UserService();
      if(!isEmail) {
        final user = await userService.getUserByUsername(account);
        if(user == null) {
          return emit(state.copyWith(accountErrorMsg: "Your username doesn't exist."));
        }
        email = user.email;
      }
      await FirebaseAuth
          .instance
          .signInWithEmailAndPassword(email: email, password: password);
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final user = await userService.getUserById(uid);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("uid", uid);
      await prefs.setString("email", user!.email);
      await prefs.setString("username", user.username);
      await prefs.setInt("gender", user.gender.index);
      await prefs.setDouble("height", user.height);
      await prefs.setDouble("weight", user.weight);
      await prefs.setString("avatarUrl", user.avatarUrl);
      emit(state.copyWith(isProcessing: true, success: true));
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          emit(state.copyWith(accountErrorMsg: "Your email address isn't valid."));
        case "user-disabled":
          emit(state.copyWith(accountErrorMsg: "Your email address has been disabled."));
        case "user-not-found":
          emit(state.copyWith(accountErrorMsg: "Your email address doesn't exist."));
          break;
        case "wrong-password":
          emit(state.copyWith(passwordErrorMsg: "Your password isn't correct."));
          break;
        case "INVALID_LOGIN_CREDENTIALS":
          emit(state.copyWith(accountErrorMsg: "Your account or password maybe incorrect."));
          break;
        default:
          rethrow;
      }
    } catch (e) {
      emit(state.copyWith(snackMsg: "Login failed, please try again!"));
      rethrow;
    }
  } 
}
