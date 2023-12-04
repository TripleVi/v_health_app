part of 'login_cubit.dart';

@immutable
final class LoginState {
  final bool passwordVisible;
  final bool isProcessing;
  final bool success;
  final String? accountErrorMsg;
  final String? passwordErrorMsg;
  final String? snackMsg;

  const LoginState({
    this.passwordVisible = false,
    this.isProcessing = false,
    this.success = false,
    this.accountErrorMsg,
    this.passwordErrorMsg,
    this.snackMsg,
  });

  LoginState copyWith({
    bool? passwordVisible,
    bool isProcessing = false,
    bool success = false,
    String? accountErrorMsg,
    String? passwordErrorMsg,
    String? snackMsg,
  }) {
    return LoginState(
      passwordVisible: passwordVisible ?? this.passwordVisible,
      isProcessing: isProcessing,
      success: success,
      accountErrorMsg: accountErrorMsg,
      passwordErrorMsg: passwordErrorMsg,
      snackMsg: snackMsg,
    );
  }
}
