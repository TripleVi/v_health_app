part of 'signup_cubit.dart';

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

  const SignUpState({
    this.passwordVisible = false,
    this.confirmPasswordVisible = false,
    this.activeIndex = 0,
    this.isProcessing = false,
    this.success = false,
    this.errorMsg,
    this.snackMsg,
  });

  SignUpState copyWith({
    bool? passwordVisible,
    bool? confirmPasswordVisible,
    int? activeIndex,
    bool isProcessing = false,
    bool? success,
    String? errorMsg,
    String? snackMsg,
  }) {
    return SignUpState(
      passwordVisible: passwordVisible ?? this.passwordVisible,
      confirmPasswordVisible: confirmPasswordVisible ?? this.confirmPasswordVisible,
      activeIndex: activeIndex ?? this.activeIndex,
      isProcessing: isProcessing,
      success: success ?? this.success,
      errorMsg: errorMsg,
      snackMsg: snackMsg,
    );
  }
}