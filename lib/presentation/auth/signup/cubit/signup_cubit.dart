import "package:firebase_auth/firebase_auth.dart" as fa;
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../../core/enum/user_enum.dart";
import "../../../../data/sources/api/user_api.dart";
import "../../../../domain/entities/user.dart";
import "../../bloc/auth_bloc.dart";

part "signup_state.dart";

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpState(
    dobController: TextEditingController(),
    heightController: TextEditingController(),
    weightController: TextEditingController(),
    usernameController: TextEditingController(),
    passwordController: TextEditingController(),
    confirmPasswordController: TextEditingController(),
    credentialFormKey: GlobalKey(),
    personalFormKey: GlobalKey(),
    fitnessFormKey: GlobalKey(),
  ));

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

  void selectGender(UserGender gender) {
    emit(state.copyWith(gender: gender));
  }

  Future<void> signUp() async {
    final user = User.empty()
    ..username = state.usernameController.text
    ..password = state.passwordController.text
    ..dateOfBirth = state.dobController.text
    ..gender = state.gender
    ..weight = double.parse(state.weightController.text.split(" ").first)
    ..height = int.parse(state.heightController.text.split(" ").first);

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
      ..name = "${profile["given_name"]} ${profile["family_name"]}"
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
      emit(state.copyWith(
        success: false,
        snackMsg: "Registration failed, please re-try!",
      ));
    }
  }

  Future<void> submitCredentialForm() async {
    emit(state.copyWith(isProcessing: true));
    final userService = UserService();
    final user = await userService
        .getUserByUsername(state.usernameController.text);
    if(user == null) return nextForm();
    emit(state.copyWith(
      errorMsg: "Username must be unique.",
    ));
  }

  @override
  Future<void> close() async {
    super.close();
    state.dobController.dispose();
    state.heightController.dispose();
    state.weightController.dispose();
    state.usernameController.dispose();
    state.passwordController.dispose();
    state.confirmPasswordController.dispose();
  }
}