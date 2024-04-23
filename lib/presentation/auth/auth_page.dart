import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/resources/style.dart';
import 'bloc/auth_bloc.dart';
import 'login/views/login_options.dart';
import 'login/views/login_page.dart';
import 'signup/views/signup_page.dart';
import 'signup/views/signup_options.dart';

class AuthPage extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();

  AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: WillPopScope(
        onWillPop: () async {
          if(_navigatorKey.currentState!.canPop()) {
            _navigatorKey.currentState?.maybePop();
            return false;
          }
          return true;
        },
        child: Navigator(
          key: _navigatorKey,
          onGenerateRoute: (settings) {
            if(settings.name == "/auth") {
              return MaterialPageRoute<void>(
                builder: (context) => const AuthView(),
                settings: settings,
              );
            }
            if(settings.name == "/signUpPage") {
              return MaterialPageRoute<bool>(
                builder: (context) => SignUpPage(),
                settings: settings,
              );
            }
            if(settings.name == "/loginPage") {
              return MaterialPageRoute<void>(
                builder: (context) => LoginPage(),
                settings: settings,
              );
            }
            return null;
          },
          initialRoute: "/auth",
        ),
      ),
    );
  }
}

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if(state.isSignedIn) {
            Navigator
              .of(context, rootNavigator: true)
              .pushNamedAndRemoveUntil("/home", (route) => false);
          }
        },
        builder: (context, state) {
          final loginPage = state.loginPage;
          return Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              loginPage ? const LoginOptions() : const SignUpOptions(),
              GestureDetector(
                onTap: () => context.read<AuthBloc>().add(PageSwitched()),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  width: double.infinity,
                  color: AppStyle.surfaceColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        loginPage ? "Don't have an account? " : "Have an account? ",
                        style: AppStyle.caption1(),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        loginPage ? "Sign up" : "Log in",
                        style: AppStyle.heading5(color: AppStyle.primaryColor),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              // isLoggedIn ? const AppLoadingIndicator() : const SizedBox(),
            ],
          );
        },
      ),
    );
  }
}
