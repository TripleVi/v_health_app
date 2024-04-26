part of "login_cubit.dart";

@immutable
final class LoginState {
  final bool passwordVisible;
  final bool isProcessing;
  final bool success;
  final String? accountErrorMsg;
  final String? snackMsg;

  final TextEditingController accountController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> loginFormKey;

  const LoginState({
    this.passwordVisible = false,
    this.isProcessing = false,
    this.success = false,
    this.accountErrorMsg,
    this.snackMsg,
    required this.accountController,
    required this.passwordController,
    required this.loginFormKey,
  });

  LoginState copyWith({
    bool? passwordVisible,
    bool isProcessing = false,
    bool success = false,
    String? accountErrorMsg,
    String? snackMsg,
  }) {
    return LoginState(
      passwordVisible: passwordVisible ?? this.passwordVisible,
      isProcessing: isProcessing,
      success: success,
      accountErrorMsg: accountErrorMsg,
      snackMsg: snackMsg,
      accountController: accountController,
      passwordController: passwordController,
      loginFormKey: loginFormKey,
    );
  }
}
