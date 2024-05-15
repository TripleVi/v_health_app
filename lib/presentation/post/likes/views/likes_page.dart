import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../../core/resources/style.dart";
import "../../../../domain/entities/reaction.dart";
import "../../../../domain/entities/user.dart";
import "../../../widgets/app_bar.dart";
import "../../../widgets/loading_indicator.dart";
import "../cubit/likes_cubit.dart";

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
      appBar: CustomAppBar.get(title: "Likes"),
      backgroundColor: AppStyle.surfaceColor,
      body: Center(
        child: Container(
          height: double.infinity,
          constraints: const BoxConstraints(maxWidth: 520.0),
          padding: const EdgeInsets.all(12.0),
          child: BlocBuilder<LikesCubit, LikesState>(
            builder: (context, state) {
              if(state is LikesLoading) {
                return const AppLoadingIndicator();
              }
              if(state is LikesLoaded) {
                return _mainSection(context, state);
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _mainSection(BuildContext context, LikesLoaded state) {
    return ListView.builder(
      itemCount: state.reactions.length,
      itemBuilder: (context, index) {
        return PeopleCard(
          user: state.user,
          reaction: state.reactions[index],
        );
      },
    );
  }
}

class PeopleCard extends StatefulWidget {
  final User user;
  final Reaction reaction;
  const PeopleCard({
    super.key,
    required this.user,
    required this.reaction,
  });

  @override
  State<PeopleCard> createState() => _PeopleCardState();
}

class _PeopleCardState extends State<PeopleCard> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    const avatarSize = 40;
    return ListTile(
      onTap: () {
        
      },
      horizontalTitleGap: AppStyle.horizontalPadding,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
      leading: CircleAvatar(
        radius: avatarSize / 2,
        backgroundColor: AppStyle.surfaceColor,
        backgroundImage: Image.asset(
          "assets/images/avatar.jpg",
          cacheWidth: avatarSize,
          cacheHeight: avatarSize,
          filterQuality: FilterQuality.high,
          isAntiAlias: true,
          fit: BoxFit.contain,
        ).image,
        foregroundImage: CachedNetworkImageProvider(
          widget.reaction.avatarUrl, 
          maxWidth: avatarSize, 
          maxHeight: avatarSize,
        ),
      ),
      title: Text(
        widget.reaction.username,
        style: AppStyle.heading5(),
      ),
      subtitle: Text(
        widget.reaction.name,
        style: AppStyle.caption1(),
      ),
      trailing: widget.reaction.uid == widget.user.uid 
          ? null
          : widget.reaction.isFollowing ? _unfollowBtn() : _followBtn()
    );
  }

  Widget _followBtn() {
    return TextButton(
      onPressed: () async {
        if(_isProcessing) return;
        setState(() {
          _isProcessing = true;
        });
        final success = await context
            .read<LikesCubit>().followPeople(widget.reaction.uid);
        await Future.delayed(const Duration(milliseconds: 300));
        if(success) {
          widget.reaction.isFollowing = true;
        }else {
          showErrorMsg();
        }
        setState(() {
          _isProcessing = false;
        });
      },
      child: _isProcessing 
          ? const SizedBox(
            width: 16.0,
            height: 16.0,
            child: CircularProgressIndicator(
              strokeWidth: 3.0,
              color: AppStyle.primaryColor,
            ),
          )
          : const Text("Follow"),
    );
  }

  Widget _unfollowBtn() {
    return TextButton(
      onPressed: () async {
        if (_isProcessing) return;
        setState(() {
          _isProcessing = true;
        });
        final success = await context
            .read<LikesCubit>().unfollowFriend(widget.reaction.uid);
        await Future.delayed(const Duration(milliseconds: 300));
        if(success) {
          widget.reaction.isFollowing = false;
        }else {
          showErrorMsg();
        }
        setState(() {
          _isProcessing = false;
        });
      },
      style: TextButton.styleFrom(
        foregroundColor: AppStyle.secondaryTextColor,
      ),
      child: _isProcessing 
          ? const SizedBox(
            width: 16.0,
            height: 16.0,
            child: CircularProgressIndicator(
              strokeWidth: 3.0,
              color: AppStyle.secondaryTextColor,
            ),
          )
          : const Text("Unfollow"),
    );
  }

  void showErrorMsg() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: AppStyle.backgroundColor,
      showCloseIcon: true,
      closeIconColor: AppStyle.secondaryIconColor,
      content: Text(
        "Oops, something went wrong!",
        style: AppStyle.bodyText(),
      ),
    ));
  }
}