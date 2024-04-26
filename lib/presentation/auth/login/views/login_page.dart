import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../../core/resources/style.dart";
import "../../../../core/utilities/utils.dart";
import "../../../widgets/app_bar.dart";
import "../../../widgets/loading_indicator.dart";
import "../cubit/login_cubit.dart";

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if(state.snackMsg != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: AppStyle.surfaceColor,
              showCloseIcon: true,
              closeIconColor: AppStyle.secondaryIconColor,
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
                backgroundColor: AppStyle.backgroundColor,
                appBar: CustomAppBar.get(title: "Log in"),
                body: Center(
                  child: Container(
                    height: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 320.0),
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 40.0),
                          _buildLoginForm(context, state),
                        ],
                      ),
                    ),
                  ),
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
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(headline, style: AppStyle.heading3()),
          const SizedBox(height: 8.0),
          Text(description, style: AppStyle.caption1()),
          const SizedBox(height: 32.0),
          Column(children: inputs),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, LoginState state) {
    return _buildPaddedForm(
      headline: "Welcome to vHealth!",
      description: "Let's start by enter your login credential",
      formKey: state.loginFormKey,
      inputs: [
        TextFormField(
          validator: MyUtils.requiredField,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: state.accountController,
          keyboardType: TextInputType.text,
          style: AppStyle.bodyText(),
          decoration: InputDecoration(
            errorMaxLines: 2,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppStyle.borderRadius)),
              borderSide: BorderSide(color: AppStyle.neutralColor400),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppStyle.borderRadius)),
              borderSide: BorderSide(color: AppStyle.neutralColor400),
            ),
            labelText: "Email or username",
            errorText: state.accountErrorMsg,
          ),
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          obscureText: !state.passwordVisible,
          validator: MyUtils.requiredField,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: state.passwordController,
          keyboardType: TextInputType.visiblePassword,
          style: AppStyle.bodyText(),
          decoration: InputDecoration(
            errorMaxLines: 2,
            suffixIcon: GestureDetector(
              onTapUp: (_) => context.read<LoginCubit>().togglePassword(),
              onTapDown: (_) => context.read<LoginCubit>().togglePassword(),
              onLongPressEnd: (_) => context.read<LoginCubit>().togglePassword(),
              child: Icon(
                state.passwordVisible ? Icons.visibility : Icons.visibility_off, 
                size: 24.0,
                color: AppStyle.secondaryIconColor,
              ),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppStyle.borderRadius)),
              borderSide: BorderSide(color: AppStyle.neutralColor400),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppStyle.borderRadius)),
              borderSide: BorderSide(color: AppStyle.neutralColor400),
            ),
            labelText: "Password",
          ),
        ),
        const SizedBox(height: 32.0),
        GestureDetector(
          onTap: () {},
          child: Text(
            "Forgot password?", 
            style: AppStyle.heading5(fontWeight: FontWeight.normal),
          ),
        ),
        const SizedBox(height: 32.0),
        submitButton(() async {
          if (!state.loginFormKey.currentState!.validate()) return;
          MyUtils.closeKeyboard(context);
          context.read<LoginCubit>().submitLoginForm();
        }),
        const SizedBox(height: 32.0),
      ],
    );
  }

  Widget submitButton(void Function() onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 52.0,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppStyle.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStyle.borderRadius),
          ),
        ),
        child: Text(
          "Log in",
          style: AppStyle.heading5(color: Colors.white),
        ),
      ),
    );
  }
}
