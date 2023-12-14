import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/resources/colors.dart';
import '../../../core/resources/style.dart';
import '../../../core/utilities/constants.dart';
import '../../../core/utilities/utils.dart';
import '../../../domain/entities/friend.dart';
import '../../widgets/appBar.dart';
import '../../widgets/loading_indicator.dart';
import '../cubit/friend_cubit.dart';

class FriendPage extends StatelessWidget {
  const FriendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FriendCubit>(
      create: (context) => FriendCubit(),
      child: const FriendView(),
    );
  }
}

class FriendView extends StatelessWidget {
  const FriendView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.get(title: "Friends"),
      backgroundColor: AppColor.backgroundColor,
      body: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: AppColor.onBackgroundColor)),
        ),
        child: BlocBuilder<FriendCubit, FriendState>(
          builder: (context, state) {
            if(state is FriendLoading) {
              return const AppLoadingIndicator();
            }
            if(state is FriendLoaded) {
              return _mainSection(context, state);
            }
            return const SizedBox();
          },
        ),
      )
    );
  }

  Widget _mainSection(BuildContext context, FriendLoaded state) {
    return Column(
      children: [
        _buildSearchBar(context, state),
        state.isProcessing
            ? const AppLoadingIndicator()
            : Expanded(
                child: _friendsList(
                  context: context,
                  friends: state.friends,
                ),
              ),
      ],
    );
  }

  //? Internet connection
  // Column(
  //   crossAxisAlignment: CrossAxisAlignment.center,
  //   mainAxisAlignment: MainAxisAlignment.center,
  //   children: [
  //     Center(
  //       child: SizedBox(
  //         width: 200,
  //         child: TextTypes.paragraph(
  //           content:
  //               'Device must be connected to the internet to use this feature',
  //           textAlign: TextAlign.center,
  //         ),
  //       ),
  //     ),
  //     Padding(
  //       padding: const EdgeInsets.only(top: 8.0),
  //       child: ElevatedButton(
  //         onPressed: () {
  //           setState(() {
  //             isConnected = ConnectionService.instance.isConnected();
  //           });
  //         },
  //         style: ElevatedButton.styleFrom(
  //           backgroundColor: AppColor.primaryColor,
  //         ),
  //         child: const Icon(Icons.refresh),
  //       ),
  //     ),
  //   ],
  // ),

  Widget _buildSearchBar(BuildContext context, FriendLoaded state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
      child: TextFormField(
        onChanged: context.read<FriendCubit>().searchUserByUsername,
        onTap: context.read<FriendCubit>().searchingStatusOn,
        controller: state.searchController,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Constants.primaryColor),
          ),
          prefixIcon: const Icon(Icons.search),
          prefixIconColor: state.isSearching 
              ? Constants.primaryColor 
              : Constants.paragraphColor,
          suffixIcon: state.isSearching
              ? Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextButton(
                      onPressed: () {
                        MyUtils.closeKeyboard(context);
                        context.read<FriendCubit>().searchingStatusOff();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Constants.primaryColor),
                      )),
                )
              : null,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Constants.paragraphColor),
          ),
          label: Text(
            "Search",
            style: TextStyle(
              color: state.isSearching
                  ? Constants.primaryColor
                  : Constants.paragraphColor
            ),
          ),
        ),
      ),
    );
  }

  Widget _friendsList({
    required BuildContext context,
    required List<Friend> friends,
  }) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppStyle.horizontalPadding,
        8.0,
        AppStyle.horizontalPadding,
        0.0,
      ),
      itemCount: friends.length,
      itemBuilder: (context, index) {
        return FriendCard(friends[index]);
      },
    );
  }
}

class FriendCard extends StatefulWidget {
  final Friend friend;
  const FriendCard(this.friend, {super.key});

  @override
  State<FriendCard> createState() => _FriendCardState();
}

class _FriendCardState extends State<FriendCard> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    const avatarSize = 40;
    final friend = widget.friend;

    return Card(
      color: AppColor.backgroundColor,
      shadowColor: AppColor.onBackgroundColor,
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppStyle.borderRadius),
      ),
      child: GestureDetector(
        onTap: () {},
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: avatarSize / 2,
                backgroundColor: AppColor.backgroundColor,
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
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${friend.lastName} ${friend.firstName}",
                      style: AppStyle.heading_3(height: 1.0),
                    ),
                    const SizedBox(height: 4.0),
                    friend.mutual == 0 
                        ? const SizedBox()
                        : Text(
                          "${friend.mutual} mutual",
                          style: AppStyle.label2(height: 1.0),
                        ),
                  ],
                ),
              ),
              const SizedBox(width: 12.0),
              friend.isFollowing
                  ? _unfollowBtn()
                  : _followBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _followBtn() {
    return SizedBox(
      width: 100.0,
      height: 40.0,
      child: TextButton(
        onPressed: () async {
          if(_isProcessing) return;
          setState(() {
            _isProcessing = true;
          });
          final success = await context.read<FriendCubit>().followFriend(widget.friend);
          await Future.delayed(const Duration(milliseconds: 300));
          if(success) {
            widget.friend.isFollowing = true;
          }
          setState(() {
            _isProcessing = false;
          });
        },
        style: TextButton.styleFrom(
          backgroundColor: AppColor.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStyle.borderRadius),
          ),
        ),
        child: _isProcessing 
            ? const SizedBox(
              width: 16.0,
              height: 16.0,
              child: CircularProgressIndicator(
                  strokeWidth: 3.0,
                  color: AppColor.secondaryColor
                ),
            )
            : Text(
              "Follow",
              style: AppStyle.heading_3(
                color: AppColor.secondaryColor,
                height: 1.0,
              ),
            ),
      ),
    );
  }

  Widget _unfollowBtn() {
    return SizedBox(
      width: 100.0,
      height: 40.0,
      child: TextButton(
        onPressed: () async {
          if (_isProcessing) return;
          setState(() {
            _isProcessing = true;
          });
          final success = await context.read<FriendCubit>().unfollowFriend(widget.friend);
          await Future.delayed(const Duration(milliseconds: 300));
          if(success) {
            widget.friend.isFollowing = false;
          }
          setState(() {
            _isProcessing = false;
          });
        },
        style: TextButton.styleFrom(
          backgroundColor: AppColor.onBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStyle.borderRadius),
          ),
        ),
        child: _isProcessing
            ? const SizedBox(
              width: 16.0,
              height: 16.0,
              child: CircularProgressIndicator(
                  strokeWidth: 3.0,
                  color: AppColor.secondaryColor
                ),
            )
            : Text(
              "Following",
              style: AppStyle.heading_3(height: 1.0),
            ),
      ),
    );
  }
}
