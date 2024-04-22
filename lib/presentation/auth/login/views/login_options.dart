import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:line_icons/line_icons.dart";

import "../../../../core/resources/style.dart";

class LoginOptions extends StatelessWidget {
  const LoginOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 100.0),
      child: Column(
        children: [
          Text("Log in to vHealth", style: AppStyle.heading3()),
          const SizedBox(height: 8.0),
          Text(
            "Manage your account, record your activities, follow other accounts, and more.",
            style: AppStyle.caption1(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32.0),
          Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              border: Border.all(color: AppStyle.neutralColor400),
              borderRadius: BorderRadius.circular(AppStyle.borderRadius),
            ),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed<void>(context, "/loginPage"),
              child: Row(
                children: [
                  const Icon(LineIcons.user, size: 20.0, color: AppStyle.secondaryIconColor),
                  Expanded(
                    child: Text(
                      "Use email or username",
                      style: AppStyle.heading5(), 
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
          // buildLoginButton(
          //   assetName: "assets/images/social_platforms/facebook.svg",
          //   logoName: "Facebook",
          //   onTap: () {},
          // ),
          // buildLoginButton(
          //   assetName: "assets/images/social_platforms/twitter.svg",
          //   logoName: "Twitter",
          //   onTap: () {},
          // ),
        ],
      ),
    );
  }

  Widget buildLoginButton({required String assetName, required String logoName, void Function()? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppStyle.neutralColor400),
        borderRadius: BorderRadius.circular(AppStyle.borderRadius),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            SvgPicture.asset(
              assetName,
              width: 20.0,
              height: 20.0,
              semanticsLabel: "$logoName logo",
            ),
            Expanded(
              child: Text(
                "Continue with $logoName", 
                style: AppStyle.heading5(), 
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}