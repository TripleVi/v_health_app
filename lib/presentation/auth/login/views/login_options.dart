import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';

import '../../../../core/resources/style.dart';

class LoginOptions extends StatelessWidget {
  const LoginOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 100.0),
      child: Column(
        children: [
          Text("Log in to vHealth", style: AppStyle.heading4(height: 1.0)),
          Container(
            margin: const EdgeInsets.only(top: 8.0, bottom: 32.0),
            child: Text(
              "Manage your account, record your activities, follow other accounts, and more.",
              style: AppStyle.caption2(),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed<void>(context, "/loginPage"),
              child: Row(
                children: [
                  const Icon(LineIcons.user, size: 28.0, color: Colors.black),
                  Expanded(
                    child: Text(
                      "Use email or username",
                      style: AppStyle.heading5(height: 1.0), 
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ),
          buildLoginButton(
            assetName: "assets/images/social_platforms/google.svg",
            logoName: "Google",
            onTap: () {},
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
                style: AppStyle.heading5(height: 1.0), 
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}