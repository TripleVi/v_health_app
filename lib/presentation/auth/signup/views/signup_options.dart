import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/resources/style.dart';
import '../../../widgets/dialog.dart';
import '../../bloc/auth_bloc.dart';

class SignUpOptions extends StatelessWidget {
  const SignUpOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if(state.authCredentialObtained) {
          Navigator
            .pushNamed<bool>(context, "/signUpPage")
            .then<void>((value) {
              if(value == null || !value) return;
              context.read<AuthBloc>().add(PageSwitched());
            });
        }else if(state.errorMsg != null) {
          MyDialog.showSingleOptionsDialog(
            context: context, 
            title: "Sign up Alert", 
            message: state.errorMsg!,
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 140.0),
        child: Column(
          children: [
            Text("Sign up for vHealth", style: AppStyle.heading_1(height: 1.0)),
            Container(
              margin: const EdgeInsets.only(top: 8.0, bottom: 32.0),
              child: Text(
                "Create a profile, follow other accounts, create your own posts, and more.",
                style: AppStyle.paragraph(),
                textAlign: TextAlign.center,
              ),
            ),
            buildLoginButton(
              assetName: "assets/images/social_platforms/google.svg",
              logoName: "Google",
              onTap: () => context.read<AuthBloc>().add(SignUpWithGoogle()),
            ),
            buildLoginButton(
              assetName: "assets/images/social_platforms/facebook.svg",
              logoName: "Facebook",
              onTap: () {},
            ),
            buildLoginButton(
              assetName: "assets/images/social_platforms/twitter.svg",
              logoName: "Twitter",
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoginButton({required String assetName, required String logoName, void Function()? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            SvgPicture.asset(
              assetName,
              width: 28.0,
              height: 28.0,
              semanticsLabel: "$logoName logo",
            ),
            Expanded(
              child: Text(
                "Continue with $logoName", 
                style: AppStyle.heading_2(height: 1.0), 
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}