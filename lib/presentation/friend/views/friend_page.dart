import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:cached_network_image/cached_network_image.dart";

import "../../../core/resources/style.dart";
import "../../../core/utilities/utils.dart";
import "../../../domain/entities/people.dart";
import "../../widgets/app_bar.dart";
import "../../widgets/loading_indicator.dart";
import "../cubit/friend_cubit.dart";

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
      appBar: CustomAppBar.get(title: "Find people"),
      backgroundColor: AppStyle.surfaceColor,
      body: Center(
        child: Container(
          height: double.infinity,
          constraints: const BoxConstraints(maxWidth: 520.0),
          padding: const EdgeInsets.all(12.0),
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
        ),
      )
    );
  }

  Widget _mainSection(BuildContext context, FriendLoaded state) {
    return Column(
      children: [
        _buildSearchBar(context, state),
        const SizedBox(height: 12.0),
        state.isProcessing
            ? const AppLoadingIndicator()
            : Expanded(
                child: _friendsList(
                  context: context,
                  people: state.people,
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
  //           backgroundColor: AppStyle.primaryColor,
  //         ),
  //         child: const Icon(Icons.refresh),
  //       ),
  //     ),
  //   ],
  // ),

  Widget _buildSearchBar(BuildContext context, FriendLoaded state) {
    return TextFormField(
      onChanged: context.read<FriendCubit>().searchUserByUsername,
      onTap: context.read<FriendCubit>().searchingStatusOn,
      controller: state.searchController,
      keyboardType: TextInputType.text,
      style: AppStyle.bodyText(),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        prefixIconColor: AppStyle.secondaryIconColor,
        suffixIcon: state.isSearching
            ? TextButton(
                onPressed: () {
                  MyUtils.closeKeyboard(context);
                  context.read<FriendCubit>().searchingStatusOff();
                },
                child: const Text("Cancel"),
              )
            : null,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppStyle.borderRadius)),
          borderSide: BorderSide(color: AppStyle.neutralColor400),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppStyle.borderRadius)),
          borderSide: BorderSide(color: AppStyle.neutralColor400),
        ),
        labelText: "Search",
      ),
    );
  }

  Widget _friendsList({
    required BuildContext context,
    required List<People> people,
  }) {
    return ListView.builder(
      itemCount: people.length,
      itemBuilder: (context, index) => PeopleCard(people[index]),
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
        final success = await context
            .read<FriendCubit>().followFriend(widget.people.uid);
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

  Widget _unfollowBtn() {
    return TextButton(
      onPressed: () async {
        if (_isProcessing) return;
        setState(() {
          _isProcessing = true;
        });
        final success = await context
            .read<FriendCubit>().unfollowFriend(widget.people.uid);
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
