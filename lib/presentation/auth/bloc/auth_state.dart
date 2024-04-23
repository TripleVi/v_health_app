part of 'auth_bloc.dart';

@immutable
final class AuthState {
  final bool loginPage;
  final bool authCredentialObtained;
  final bool isSignedIn;
  final String? errorMsg;

  const AuthState({
    this.loginPage = true, 
    this.authCredentialObtained = false,
    this.isSignedIn = false,
    this.errorMsg,
  });

  AuthState copyWith({
    bool? loginPage,
    bool authCredentialObtained = false,
    bool? isSignedIn,
    String? errorMsg,
  }) {
    return AuthState(
      loginPage: loginPage ?? this.loginPage,
      authCredentialObtained: authCredentialObtained,
      isSignedIn: isSignedIn ?? this.isSignedIn,
      errorMsg: errorMsg,
    );
  }
}