import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:flutter/material.dart';

import '../../../../data/sources/api/user_api.dart';
import '../../../../domain/entities/user.dart';
import '../../bloc/auth_bloc.dart';

part 'signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(const SignUpState());

  void togglePassword() {
    emit(state.copyWith(passwordVisible: !state.passwordVisible));
  }

  void toggleConfirmPassword() {
    emit(state.copyWith(confirmPasswordVisible: !state.confirmPasswordVisible));
  }

  void nextForm() {
    emit(state.copyWith(activeIndex: state.activeIndex+1));
  }

  void previousForm() {
    emit(state.copyWith(activeIndex: state.activeIndex-1));
  }

  void refreshPage() {
    emit(state.copyWith());
  }

  Future<void> signUp(User user) async {
    emit(state.copyWith(isProcessing: true));
    try {
      user.email = AuthBloc.email!;
      var userCredential = await fa.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email, password: user.password,
      );
      userCredential = await userCredential.user!.linkWithCredential(AuthBloc.authCredential!);
      final profile = userCredential.additionalUserInfo!.profile!;
      user
      ..uid = userCredential.user!.uid
      ..firstName = profile["given_name"]
      ..lastName = profile["family_name"]
      ..avatarUrl = profile["picture"];
      final userService = UserService();
      await userService.createUser(user);
      await fa.FirebaseAuth.instance.signOut();
      emit(state.copyWith(
        success: true,
        isProcessing: true,
        snackMsg: "Registration succeeded, please login!",
      ));
    } catch (e) {
      print(e);
      emit(state.copyWith(
        success: false,
        snackMsg: "Registration failed, please re-try!",
      ));
    }
  }

  Future<void> submitCredentialForm(String username, String password) async {
    emit(state.copyWith(isProcessing: true));
    final userService = UserService();
    final user = await userService.getUserByUsername(username);
    if(user == null) return nextForm();
    emit(state.copyWith(
      errorMsg: "Your username must be unique.",
    ));
  }
}