import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";

import "../../../../core/resources/style.dart";
import "../../../../domain/entities/user.dart";
import "../../../data/sources/api/people_service.dart";
import "../../../data/sources/api/user_api.dart";
import "../../../domain/entities/people.dart";
import "../../widgets/app_bar.dart";
import "../../widgets/loading_indicator.dart";

class FollowingPage extends StatelessWidget {
  const FollowingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = ModalRoute.of(context)!.settings.arguments as String;
    return FollowingView(uid: uid);
  }
}

class FollowingView extends StatefulWidget {
  final String uid;
  const FollowingView({super.key, required this.uid});

  @override
  State<FollowingView> createState() => _FollowingViewState();
}

class _FollowingViewState extends State<FollowingView> {
  var loading = true;
  final following = <People>[];
  late final User user;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final service = UserService();
    user = (await service.getUserById(widget.uid))!;
    final result = await service.getFollowing(user.uid);
    setState(() {
      following.addAll(result);
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.get(title: "Following"),
      backgroundColor: AppStyle.surfaceColor,
      body: Center(
        child: Container(
          height: double.infinity,
          constraints: const BoxConstraints(maxWidth: 520.0),
          padding: const EdgeInsets.all(12.0),
          child: loading 
              ? const AppLoadingIndicator() 
              : following.isEmpty ? const SizedBox() : _mainSection(context),
        ),
      ),
    );
  }

  Widget _mainSection(BuildContext context) {
    return ListView.builder(
      itemCount: following.length,
      itemBuilder: (context, index) {
        return PeopleCard(following[index]);
      },
    );
  }
}

class PeopleCard extends StatefulWidget {
  final People people;
  const PeopleCard(this.people, {super.key});

  @override
  State<PeopleCard> createState() => _PeopleCardState();
}

class _PeopleCardState extends State<PeopleCard> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    const avatarSize = 40;
    final friend = widget.people;
    return ListTile(
      onTap: () {
        final user = User.empty()
        ..uid = widget.people.uid;
        Navigator.pushNamed(context, "/other", arguments: user);
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
          friend.avatarUrl, 
          maxWidth: avatarSize, 
          maxHeight: avatarSize,
        ),
      ),
      title: Text(
        friend.username,
        style: AppStyle.heading5(),
      ),
      subtitle: Text(
        friend.name,
        style: AppStyle.caption1(),
      ),
      trailing: friend.isFollowing ? _unfollowBtn() : _followBtn(),
    );
  }

  Widget _followBtn() {
    return TextButton(
      onPressed: () async {
        if(_isProcessing) return;
        setState(() {
          _isProcessing = true;
        });
        final success = await followFriend(widget.people.uid);
        await Future.delayed(const Duration(milliseconds: 300));
        if(success) {
          widget.people.isFollowing = true;
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

  Future<bool> followFriend(String uid) async {
    final service = PeopleService();
    final isFollowing = await service.followPeople(uid);
    if(!isFollowing) {
      showErrorMsg();
    }
    return isFollowing;
  }

  Widget _unfollowBtn() {
    return TextButton(
      onPressed: () async {
        if (_isProcessing) return;
        setState(() {
          _isProcessing = true;
        });
        final success = await unfollowFriend(widget.people.uid);
        await Future.delayed(const Duration(milliseconds: 300));
        if(success) {
          widget.people.isFollowing = false;
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

  Future<bool> unfollowFriend(String uid) async {
    final service = PeopleService();
    final isUnfollowing = await service.unfollowPeople(uid);
    if(!isUnfollowing) {
      showErrorMsg();
    }
    return isUnfollowing;
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