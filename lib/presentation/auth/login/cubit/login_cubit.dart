import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../../core/services/shared_pref_service.dart";
import "../../../../core/utilities/utils.dart";
import "../../../../data/sources/api/user_api.dart";

part "login_state.dart";

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState(
    accountController: TextEditingController(),
    passwordController: TextEditingController(),
    loginFormKey: GlobalKey(),
  ));

  void togglePassword() {
    emit(state.copyWith(passwordVisible: !state.passwordVisible));
  }

  Future<void> submitLoginForm() async {
    final account = state.accountController.text;
    final password = state.passwordController.text;
    // if(MyUtils.passwordValidator(password) != null 
    //     || MyUtils.emailValidator(account) != null 
    //     && MyUtils.usernameValidator(account) != null) {
    //   return emit(state
    //       .copyWith(accountErrorMsg: "Your account or password may be incorrect."));
    // }
    const loginError = "Your account or password may be incorrect.";
    try {
      emit(state.copyWith(isProcessing: true));
      final isEmail = account.contains('@');
      var email = account;
      final userService = UserService();
      if(!isEmail) {
        final user = await userService.getUserByUsername(account);
        if(user == null) {
          return emit(state
              .copyWith(accountErrorMsg: loginError));
        }
        email = user.email;
      }
      await FirebaseAuth
          .instance
          .signInWithEmailAndPassword(email: email, password: password);
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final user = await userService.getUserById(uid);
      await SharedPrefService.createCurrentUser(user!);
      emit(state.copyWith(isProcessing: true, success: true));
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-credential":
        case "invalid-email":
        case "user-disabled":
        case "user-not-found":
        case "wrong-password":
        case "INVALID_LOGIN_CREDENTIALS":
          emit(state.copyWith(accountErrorMsg: loginError));
          break;
        default:
          rethrow;
      }
    } catch (e) {
      emit(state.copyWith(snackMsg: "Login failed, please try again!"));
      rethrow;
    }
  }

  @override
  Future<void> close() async {
    super.close();
    state.accountController.dispose();
    state.passwordController.dispose();
  }
}
