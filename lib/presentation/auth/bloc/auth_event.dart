part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class SignUpWithGoogle extends AuthEvent {}

class PageSwitched extends AuthEvent {}

class RefreshPage extends AuthEvent {}