import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/services/auth_service.dart';
import '../../../data/sources/api/user_api.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  static String? _email;
  static AuthCredential? _authCredential;

  AuthBloc() : super(const AuthState()) {
    on<PageSwitched>(_onPageSwitched);
    on<SignUpWithGoogle>(_onSignUpWithGoogle);
  }

  static String? get email {
    return _email;
  }

  static AuthCredential? get authCredential {
    return _authCredential;
  }

  void _onPageSwitched(PageSwitched event, Emitter<AuthState> emit) {
    emit(state.copyWith(loginPage: !state.loginPage));
  }

  Future<void> _onSignUpWithGoogle(SignUpWithGoogle event, Emitter<AuthState> emit) async {
    final authService = AuthService();
    final googleUser = await authService.getGoogleSignInAccount();
    if(googleUser == null) return;
    // final userService = UserService();
    // final result = await userService.emailExists(googleUser.email);
    // if(result) {
    //   return emit(state.copyWith(
    //     errorMsg: "Your email is already registered. Please try another one.",
    //   ));
    // }
    _email = googleUser.email;
    _authCredential = await authService.createGoogleAuthCredential();
    emit(state.copyWith(authCredentialObtained: true));
  }
}
