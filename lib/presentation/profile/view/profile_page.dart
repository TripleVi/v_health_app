import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;

import '../../../core/resources/colors.dart';
import '../../../core/resources/style.dart';
import '../../settings/view/settings_page.dart';
import '../../widgets/appBar.dart';
import '../../widgets/loading_indicator.dart';
import '../bloc/profile_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (context) => ProfileBloc(),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  Widget _buildSettingsBtn(BuildContext context) {
    return IconButton(
      onPressed: () async {
        // Navigator.push(
        //   context, 
        //   MaterialPageRoute(
        //     builder: (context) => const SettingsPage(),
        //   )
        // );
        await fa.FirebaseAuth.instance.signOut();
        Navigator.pushNamedAndRemoveUntil(context, "/auth", (route) => true);
      },
      icon: const Icon(
        Icons.settings_outlined,
        size: 24.0,
        color: AppColor.primaryColor,
      ),
    );
  }

  Widget _buildSecondaryButton({
    required String label, 
    required void Function() onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          vertical: 4.0,
          horizontal: 16.0,
        ),
        backgroundColor: AppColor.backgroundColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 2.0,
            color: AppColor.primaryColor,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      child: Text(
        label,
        style: AppStyle.heading_2(
          color: AppColor.primaryColor,
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, ProfileLoaded state) {
    final user = state.user;
    const iconSize = 72;
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: CustomAppBar.get(
        title: user.username,
        actions: [
          _buildSettingsBtn(context),
        ]
      ),
      body: Column(
        children: [
          Divider(
            height: 1.0,
            thickness: 1.0,
            color: AppColor.onBackgroundColor,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppStyle.horizontalPadding,
              vertical: 16.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: iconSize / 2,
                      backgroundColor: AppColor.backgroundColor,
                      backgroundImage: Image.asset(
                        "assets/images/avatar.jpg",
                        cacheWidth: iconSize,
                        cacheHeight: iconSize,
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.contain,
                        isAntiAlias: true,
                      ).image,
                      foregroundImage: CachedNetworkImageProvider(
                        state.user.avatarUrl, 
                        maxWidth: iconSize, 
                        maxHeight: iconSize,
                      ),
                    ),
                    const SizedBox(width: 40.0),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("3", style: AppStyle.heading_2()),
                              Text("Posts", style: AppStyle.paragraph()),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("${state.followers}", style: AppStyle.heading_2()),
                              Text("Followers", style: AppStyle.paragraph()),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("${state.followings}", style: AppStyle.heading_2()),
                              Text("Following", style: AppStyle.paragraph()),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Text(user.username, style: AppStyle.heading_2()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // _buildSecondaryButton(
                    //   label: "Edit profile",
                    //   onPressed: () {
                        
                    //   },
                    // ),
                    // _buildSecondaryButton(
                    //   label: "Share profile",
                    //   onPressed: () {
                        
                    //   },
                    // ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if(state is ProfileLoading) {
          return Scaffold(
            backgroundColor: AppColor.backgroundColor,
            appBar: CustomAppBar.get(
              title: "",
            ),
            body: Column(
              children: [
                Divider(
                  height: 1.0,
                  thickness: 1.0,
                  color: AppColor.onBackgroundColor,
                ),
                const Expanded(
                  child: AppLoadingIndicator(),
                ),
              ],
            ),
          );
        }
        if(state is ProfileLoaded) {
          return _buildPage(context, state);
        }
        return const SizedBox();
      },
    );
  }
}