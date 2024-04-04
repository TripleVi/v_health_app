import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/resources/style.dart';
import '../../../../domain/entities/reaction.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/loading_indicator.dart';
import '../cubit/likes_cubit.dart';

class LikesPage extends StatelessWidget {
  const LikesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final postId = ModalRoute.of(context)!.settings.arguments as String;
    return BlocProvider<LikesCubit>(
      create: (context) => LikesCubit(postId),
      child: const LikesView(),
    );
  }
}

class LikesView extends StatelessWidget {
  const LikesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.surfaceColor,
      appBar: CustomAppBar.get(
        title: "Likes",
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          }, 
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 24.0,
            color: AppStyle.neutralColor400,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: AppStyle.neutralColor400)),
        ),
        child: BlocBuilder<LikesCubit, LikesState>(
          builder: (context, state) {
            if(state is LikesLoading) {
              return const AppLoadingIndicator();
            }
            if(state is LikesLoaded) {
              return _listView(state.reactions);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _followButton() {
    return SizedBox(
      width: 100.0,
      height: 40.0,
      child: TextButton(
        onPressed: () {

        },
        style: TextButton.styleFrom(
          backgroundColor: AppStyle.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStyle.borderRadius),
          ),
        ),
        child: Text(
          "Follow",
          style: AppStyle.bodyText(
            color: AppStyle.surfaceColor,
            height: 1.0,
          ),
        ),
      ),
    );
  }

  ListView _listView(List<Reaction> reactions) {
    const avatarSize = 40;
    return ListView.builder(
      itemCount: reactions.length,
      itemBuilder: (context, index) {
        final reaction = reactions[index];
        return ListTile(
          onTap: () {
            
          },
          horizontalTitleGap: AppStyle.horizontalPadding,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppStyle.horizontalPadding,
          ),
          leading: CircleAvatar(
            radius: avatarSize/2,
            backgroundColor: AppStyle.surfaceColor,
            backgroundImage: Image.asset(
              "assets/images/avatar.jpg",
              cacheWidth: avatarSize,
              cacheHeight: avatarSize,
              filterQuality: FilterQuality.high,
              isAntiAlias: true,
              fit: BoxFit.contain,
            ).image,
            foregroundImage: Image.network(
              reaction.avatarUrl,
              cacheWidth: avatarSize,
              cacheHeight: avatarSize,
              filterQuality: FilterQuality.high,
              isAntiAlias: true,
              fit: BoxFit.contain,
            ).image
          ),
          title: Text(
            reaction.username,
            style: AppStyle.heading2(height: 1.0),
          ),
          subtitle: Text(
            "${reaction.firstName} ${reaction.lastName}",
            style: AppStyle.bodyText(height: 1.0),
          ),
          trailing: _followButton(),
        );
      }
    );
  }
}