import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../core/resources/style.dart";
import "../../friend/views/friend_page.dart";
import "../../widgets/app_bar.dart";
import "../../widgets/loading_indicator.dart";
import "../cubit/profile_cubit.dart";
import "../details/views/profile_details_page.dart";
import "../details/views/profile_form_page.dart";
import "../settings/views/settings_page.dart";

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (context) => ProfileCubit(),
      child: Navigator(
        onGenerateRoute: (settings) {
          if(settings.name == "/profile") {
            return MaterialPageRoute<void>(
              builder: (context) => const ProfileView(),
              settings: settings,
            );
          }
          if(settings.name == "/profileDetails") {
            return MaterialPageRoute<void>(
              builder: (context) => const ProfileDetailsPage(),
              settings: settings,
            );
          }
          if(settings.name == "/profileForm") {
            return MaterialPageRoute<bool>(
              builder: (context) => const ProfileFormPage(),
              settings: settings,
            );
          }
          if(settings.name == "/settings") {
            return MaterialPageRoute<void>(
              builder: (context) => const SettingsPage(),
              settings: settings,
            );
          }
          if(settings.name == "/search") {
            return MaterialPageRoute<void>(
              builder: (context) => const FriendPage(),
              settings: settings,
            );
          }
          return null;
        },
        initialRoute: "/profile",
      ),
    );
  }
}

class ProfileView extends StatelessWidget {
  static const iconSize = 72;
  
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if(state is ProfileInitial) {
          return const SizedBox();
        }
        if(state is ProfileLoading) {
          return Scaffold(
            appBar: CustomAppBar.get(title: state.user.username),
            backgroundColor: AppStyle.backgroundColor,
            body: const AppLoadingIndicator(),
          );
        }
        state as ProfileLoaded;
        return Scaffold(
          appBar: CustomAppBar.get(
            title: state.user.username,
            actions: appBarActions(context),
          ),
          backgroundColor: AppStyle.backgroundColor,
          body: Container(
            height: double.infinity,
            constraints: const BoxConstraints(maxWidth: 520.0),
            padding: const EdgeInsets.all(12.0),
            child: _mainContent(context, state),
          ),
        );
      },
    );
  }

  List<Widget> appBarActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => Navigator.pushNamed<void>(context, "/settings"),
        icon: const Icon(Icons.settings_outlined),
      ),
    ];
  }

  Widget _mainContent(BuildContext context, ProfileLoaded state) {
    return RefreshIndicator(
      color: AppStyle.primaryColor,
      onRefresh: context.read<ProfileCubit>().pullToRefresh,
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height-172,
          ),
          child: Column(
            children: [
              const SizedBox(height: iconSize/2),
              _userInfoWidget(context, state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userInfoWidget(BuildContext context, ProfileLoaded state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: AppStyle.surfaceColor,
        borderRadius: BorderRadius.circular(AppStyle.borderRadius),
      ),
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 80),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("${state.followings}", style: AppStyle.heading5()),
                        Text("following", style: AppStyle.caption2()),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("${state.followers}", style: AppStyle.heading5()),
                        Text("followers", style: AppStyle.caption2()),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("10", style: AppStyle.heading5()),
                        Text("posts", style: AppStyle.caption2()),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _secondaryButton(
                    content: const Text("Edit profile"),
                    onPressed: () => Navigator.pushNamed(context, "/profileDetails"),
                  ),
                  _secondaryButton(
                    content: const Text("Share profile"),
                    onPressed: () {},
                  ),
                  _secondaryButton(
                    content: const Icon(Icons.person_add_rounded, size: 24.0),
                    onPressed: () => Navigator.pushNamed(context, "/search"),
                  )
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
          Positioned(
            top: -iconSize/2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: iconSize / 2,
                  backgroundColor: AppStyle.surfaceColor,
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
                const SizedBox(height: 4.0),
                Text(state.user.name, style: AppStyle.heading5()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _secondaryButton({
    required Widget content,
    required void Function() onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        textStyle: AppStyle.caption1Bold(),
        iconColor: AppStyle.sBtnTextColor,
        backgroundColor: AppStyle.sBtnBgColor,
        foregroundColor: AppStyle.sBtnTextColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppStyle.borderRadius),
        ),
      ),
      child: content,
    );
  }
}