import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/resources/style.dart';
import '../../../../core/utilities/utils.dart';
import '../../../widgets/appBar.dart';
import '../../../widgets/loading_indicator.dart';
import '../cubit/login_cubit.dart';

class LoginPage extends StatelessWidget {
  final _accountController = TextEditingController();
  final _passwordController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if(state.snackMsg != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                state.snackMsg!,
                style: AppStyle.bodyText(),
              ),
            ));
          }
          if(state.success) {
            Navigator
              .of(context, rootNavigator: true)
              .pushNamedAndRemoveUntil("/home", (route) => false);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                backgroundColor: AppStyle.surfaceColor,
                appBar: CustomAppBar.get(
                  title: "Log in",
                  leading: GestureDetector(
                    onTap: () => Navigator.pop<void>(context),
                    child: const Icon(Icons.arrow_back_rounded, size: 32.0),
                  ),
                ),
                body: SingleChildScrollView(
                  child: _buildLoginForm(context, state),
                ),
              ),
              state.isProcessing 
                ? const AppProcessingIndicator() 
                : const SizedBox(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPaddedForm({
    required List<Widget> inputs,
    required String headline,
    required String description,
    required GlobalKey<FormState> formKey,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40.0),
            Text(headline, style: AppStyle.heading1(height: 1.0)),
            const SizedBox(height: 4.0),
            Text(description, style: AppStyle.bodyText()),
            const SizedBox(height: 28.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: inputs,
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _getInputDecoration(String labelText, String? errorText) {
    return InputDecoration(
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      labelText: labelText,
      errorText: errorText,
      contentPadding: const EdgeInsets.all(20.0),
    );
  }

  Widget _buildLoginForm(BuildContext context, LoginState state) {
    return _buildPaddedForm(
      headline: "Welcome to vHealth!",
      description: "Let's start by enter your login credential",
      formKey: _loginFormKey,
      inputs: [
        TextFormField(
          validator: MyUtils.requiredField,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _accountController,
          keyboardType: TextInputType.text,
          decoration: _getInputDecoration(
            "Email or username", 
            state.accountErrorMsg,
          ),
        ),
        const SizedBox(height: 20.0),
        TextFormField(
          obscureText: !state.passwordVisible,
          validator: MyUtils.requiredTextField,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _passwordController,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            suffixIcon: GestureDetector(
              onTapUp: (_) => context.read<LoginCubit>().togglePassword(),
              onTapDown: (_) => context.read<LoginCubit>().togglePassword(),
              onLongPressEnd: (_) =>
                  context.read<LoginCubit>().togglePassword(),
              child: state.passwordVisible
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            labelText: "Password",
            errorText: state.passwordErrorMsg,
            contentPadding: const EdgeInsets.all(20.0),
          ),
        ),
        const SizedBox(height: 24.0),
        GestureDetector(
          onTap: () {},
          child: Text("Forgot password?", style: AppStyle.heading2(height: 1.0)),
        ),
        const SizedBox(height: 24.0),
        _buildNextButton(() {
          // if (!_loginFormKey.currentState!.validate()) return;
          MyUtils.closeKeyboard(context);
          context.read<LoginCubit>().submitLoginForm(
              _accountController.text, _passwordController.text,
          );
        }),
        const SizedBox(height: 32.0),
      ],
    );
  }

  Widget _buildNextButton(void Function() onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 52.0,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppStyle.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Text(
          "Log in",
          style: AppStyle.heading2(height: 1.0, color: Colors.white),
        ),
      ),
    );
  }
}
