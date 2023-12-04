part of 'auth_bloc.dart';

@immutable
final class AuthState {
  final bool loginPage;
  final bool authCredentialObtained;
  final String? errorMsg;

  const AuthState({
    this.loginPage = true, 
    this.authCredentialObtained = false,
    this.errorMsg,
  });

  AuthState copyWith({
    bool? loginPage,
    bool authCredentialObtained = false,
    String? errorMsg,
  }) {
    return AuthState(
      loginPage: loginPage ?? this.loginPage,
      authCredentialObtained: authCredentialObtained,
      errorMsg: errorMsg,
    );
  }
}