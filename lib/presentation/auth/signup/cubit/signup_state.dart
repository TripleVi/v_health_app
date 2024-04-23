part of "signup_cubit.dart";

@immutable
final class SignUpState {
  final bool passwordVisible;
  final bool confirmPasswordVisible;
  final int activeIndex;
  final int totalIndex = 2;
  final bool isProcessing;
  final bool success;
  final String? errorMsg;
  final String? snackMsg;
  final TextEditingController dobController;
  final TextEditingController heightController;
  final TextEditingController weightController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final GlobalKey<FormState> credentialFormKey;
  final GlobalKey<FormState> personalFormKey;
  final GlobalKey<FormState> fitnessFormKey;
  final UserGender gender;

  const SignUpState({
    this.passwordVisible = false,
    this.confirmPasswordVisible = false,
    this.activeIndex = 0,
    this.isProcessing = false,
    this.success = false,
    this.errorMsg,
    this.snackMsg,
    required this.dobController,
    required this.heightController,
    required this.weightController,
    required this.usernameController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.credentialFormKey,
    required this.personalFormKey,
    required this.fitnessFormKey,
    this.gender = UserGender.male,
  });

  SignUpState copyWith({
    bool? passwordVisible,
    bool? confirmPasswordVisible,
    int? activeIndex,
    bool isProcessing = false,
    bool? success,
    String? errorMsg,
    String? snackMsg,
    UserGender? gender,
  }) {
    return SignUpState(
      passwordVisible: passwordVisible ?? this.passwordVisible,
      confirmPasswordVisible: confirmPasswordVisible ?? this.confirmPasswordVisible,
      activeIndex: activeIndex ?? this.activeIndex,
      isProcessing: isProcessing,
      success: success ?? this.success,
      errorMsg: errorMsg,
      snackMsg: snackMsg,
      dobController: dobController,
      heightController: heightController,
      weightController: weightController,
      usernameController: usernameController,
      passwordController: passwordController,
      confirmPasswordController: confirmPasswordController,
      credentialFormKey: credentialFormKey,
      personalFormKey: personalFormKey,
      fitnessFormKey: fitnessFormKey,
      gender: gender ?? this.gender,
    );
  }
}