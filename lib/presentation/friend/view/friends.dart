// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';

// import '../../../core/resources/colors.dart';
// import '../../../core/resources/style.dart';
// import '../../../core/services/connection_service.dart';
// import '../../../core/utilities/constants.dart';
// import '../../../core/utilities/utils.dart';
// import '../../../data/repositories/user_repo.dart';
// import '../../../data/sources/firestore/dao/user_firestore.dart';
// import '../../../domain/entities/user.dart';
// import '../../../domain/usecases/friend/fetch_followers.dart';
// import '../../../domain/usecases/friend/follow_user.dart';
// import '../../../domain/usecases/friend/unfollow_user.dart';
// import '../../widgets/appBar.dart';
// import '../../widgets/loading_indicator.dart';
// import '../../widgets/text.dart';

// class FriendsActivity extends StatefulWidget {
//   const FriendsActivity({super.key});

//   @override
//   State<StatefulWidget> createState() => _FriendsActivityState();
// }

// class _FriendsActivityState extends State<FriendsActivity> {
//   final _userFuture = GetIt.instance<UserRepo>().getUserSession();
//   List<User> _friends = [];

//   bool isConnected = ConnectionService.instance.isConnected();
//   TextEditingController searchController = TextEditingController();
//   bool _isSearch = false;
//   bool _isProcessing = false;

//   @override
//   void initState() {
//     super.initState();
//     if (isConnected) {

//     }
//   }

//   Widget _mainSection() {
//     return FutureBuilder<User>(
//       future: _userFuture,
//       builder: (context, snapshot) {
//         if(snapshot.hasData) {
//           return Column(
//             children: [
//               searchBar,
//               _isProcessing
//                 ? const AppLoadingIndicator()
//                 : Expanded(
//                   child: _friendList(
//                     context: context,
//                     me: snapshot.data!,
//                     friends: _friends,
//                   ),
//                 ),
//             ],
//           );
//         }
//         if(snapshot.connectionState == ConnectionState.waiting) {
//           return const AppLoadingIndicator();
//         }
//         return Center(
//           child: Text(
//             "Something went wrong. Please try again!",
//             style: AppStyle.heading_2(),
//           ),
//         );
//       }
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar.get(title: "Find Friends"),
//       body: isConnected
//         ? _mainSection()
//         : Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Center(
//                 child: SizedBox(
//                   width: 200,
//                   child: TextTypes.paragraph(
//                     content:
//                         'Device must be connected to the internet to use this feature',
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       isConnected = ConnectionService.instance.isConnected();
//                     });
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColor.primaryColor,
//                   ),
//                   child: const Icon(Icons.refresh),
//                 ),
//               ),
//             ],
//           ),
//     );
//   }

//   Widget get searchBar {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: TextFormField(
//         onChanged: (value) {
//           searchUsers(value);
//         },
//         onTap: () {
//           setState(() {
//             _isSearch = true;
//           });
//         },
//         controller: searchController,
//         decoration: InputDecoration(
//             focusedBorder: const OutlineInputBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(20)),
//                 borderSide: BorderSide(color: Constants.primaryColor)),
//             prefixIcon: const Icon(Icons.search),
//             prefixIconColor:
//                 _isSearch ? Constants.primaryColor : Constants.paragraphColor,
//             suffixIcon: _isSearch
//                 ? Padding(
//                     padding: const EdgeInsets.only(right: 8.0),
//                     child: TextButton(
//                         onPressed: () {
//                           MyUtils.closeKeyboard(context);
//                           setState(() {
//                             _isSearch = false;
//                             searchController.text = "";
//                             setState(() {
//                               _isProcessing = false;
//                               _friends = [];
//                             });
//                           });
//                         },
//                         child: const Text(
//                           "Cancel",
//                           style: TextStyle(color: Constants.primaryColor),
//                         )),
//                   )
//                 : null,
//             border: const OutlineInputBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(20)),
//                 borderSide: BorderSide(color: Constants.paragraphColor)),
//             label: Text(
//               "Search",
//               style: TextStyle(
//                   color: _isSearch
//                       ? Constants.primaryColor
//                       : Constants.paragraphColor),
//             )),
//       ),
//     );
//   }

//   Future<void> searchUsers(String keyword) async {
//     if(_isProcessing) return;
//     setState(() {
//       _isProcessing = true;
//     });
//     if (keyword == "") {
//       setState(() {
//         _isProcessing = false;
//         _friends = [];
//       });
//       return;
//     } else if (keyword.length == 36) {
//       print('searching by id');
//       User fetched = await UserFirestore.instance.searchUserById(keyword);
//       setState(() {
//         _isProcessing = false;
//         _friends = [fetched];
//       });
//       return;
//     } else {
//       final me = await _userFuture;
//       final fetched = await UserFirestore.instance.searchUser(
//         keyword, 
//         me.username,
//       );
//       final useCase = GetIt.instance<FetchFollowersUseCase>();
//       final followers = await useCase(params: me.id);
//       for(final f in followers) {
//         final temp = fetched.firstWhere((u) => f.id == u.id);
//         fetched.remove(temp);
//       }
//       setState(() {
//         _friends = fetched;
//         _isProcessing = false;
//       });
//     }
//   }

//   Widget _friendList({
//     required BuildContext context,
//     required User me,
//     required List<User> friends,
//   }) {
//     return ListView.builder(
//       padding: const EdgeInsets.fromLTRB(
//         AppStyle.horizontalPadding, 20.0,
//         AppStyle.horizontalPadding, 0.0,
//       ),
//       itemCount:friends.length,
//       itemBuilder: (context, index) {
//         return FriendCard(
//           me: me,
//           friend: friends[index],
//           myFollowers: friends,
//         );
//       },
//     );
//   }
// }

// class FriendCard extends StatefulWidget {
//   final User me;
//   final User friend;
//   final List<User> myFollowers;
//   const FriendCard({
//     super.key,
//     required this.me, 
//     required this.friend, 
//     required this.myFollowers,
//   });

//   @override
//   State<FriendCard> createState() => _FriendCardState();
// }

// class _FriendCardState extends State<FriendCard> {
//   bool _isProcessing = false;
//   bool _isFollowing = false;

//   Future<String> _sharedFriend(User friend, List<User> myFollowers) async {
//     final useCase = GetIt.instance<FetchFollowersUseCase>();
//     final followers = await useCase(params: friend.id);
//     final value = followers.map<String>((f) => f.id).toSet();
//     final value2 = myFollowers.map<String>((f) => f.id).toSet();
//     final total = value.intersection(value2).length;
//     return "$total mutual friend${total < 2 ? "" : "s"}";
//   }

//   Future<bool?> _showConfirmDialog(BuildContext context) {
//     return showDialog<bool>(
//       context: context,
//       builder: (BuildContext context) {
//         MyUtils.closeKeyboard(context);
//         return AlertDialog(
//           title: Text(
//             "Unfollow Confirmation",
//             style: AppStyle.heading_2(height: 1.0),
//           ),
//           content: Text(
//             "Are you sure to unfollow this user?",
//             style: AppStyle.paragraph(),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop<bool>(context, true),
//               child: Text("Unfollow",
//                 style: AppStyle.label(
//                   color: AppColor.dangerColor,
//                   height: 1.0,
//                 ),
//               ),
//             ),
//             TextButton(
//               onPressed: () => Navigator.pop<bool>(context, false),
//               child: Text("Cancel",
//                 style: AppStyle.label(
//                   height: 1.0,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _followBtn(User followedUser, User follower) {
//     return SizedBox(
//       width: 100.0,
//       height: 40.0,
//       child: TextButton(
//         onPressed: () async {
//           if(_isProcessing) return;
//           _isProcessing = true;
//           final useCase = GetIt.instance<FollowUserUseCase>();
//           await useCase(params: FollowUserParams(followedUser, follower));
//           setState(() {
//             _isProcessing = false;
//             _isFollowing = true;
//           });
//         },
//         style: TextButton.styleFrom(
//           backgroundColor: AppColor.primaryColor,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(AppStyle.borderRadius),
//           ),
//         ),
//         child: Text("Follow",
//           style: AppStyle.paragraph(
//             color: AppColor.secondaryColor,
//             height: 1.0,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _unfollowBtn({
//     required BuildContext context,
//     required User followedUser,
//     required User follower,
//   }) {
//     return SizedBox(
//       width: 100.0,
//       height: 40.0,
//       child: TextButton(
//         onPressed: () async {
//           if(_isProcessing) return;
//           _isProcessing = true;
//           final isOK = await _showConfirmDialog(context);
//           if(isOK == true) {
//             GetIt.instance<UnfollowUserUseCase>()(
//               params: UnfollowUserParams(followedUser.id, follower.id),
//             );
//             _isFollowing = false;
//           }
//           setState(() {
//             _isProcessing = false;
//           });
//         },
//         style: TextButton.styleFrom(
//           backgroundColor: Colors.grey.shade400,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(AppStyle.borderRadius),
//           ),
//         ),
//         child: Text("Unfollow",
//           style: AppStyle.paragraph(
//             color: Colors.black87,
//             height: 1.0,
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     const avatarSize = 40;
//     final me = widget.me;
//     final friend = widget.friend;
//     final myFollowers = widget.myFollowers;

//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: SizedBox(
//           width: double.infinity,
//           child: Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(right: 15.0),
//                       child: CircleAvatar(
//                         radius: avatarSize/2,
//                         backgroundColor: AppColor.backgroundColor,
//                         backgroundImage: Image.asset(
//                           "assets/images/avatar.jpg",
//                           cacheWidth: avatarSize,
//                           cacheHeight: avatarSize,
//                           filterQuality: FilterQuality.high,
//                           isAntiAlias: true,
//                           fit: BoxFit.contain,
//                         ).image,
//                         foregroundImage: friend.avatarUrl.isEmpty
//                             ? null
//                             : Image.network(
//                                 friend.avatarUrl,
//                                 cacheWidth: avatarSize,
//                                 cacheHeight: avatarSize,
//                                 filterQuality: FilterQuality.high,
//                                 isAntiAlias: true,
//                                 fit: BoxFit.contain,
//                               ).image,
//                       ),
//                     ),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           constraints: const BoxConstraints(
//                             maxHeight: 100, 
//                             maxWidth: 200, 
//                             minWidth: 100,
//                           ),
//                           child: TextTypes.heading_1(
//                             content: "${friend.lastName} ${friend.firstName}",
//                             fontSize: 16,
//                           ),
//                         ),
//                         FutureBuilder<String>(
//                           future: _sharedFriend(friend, myFollowers),
//                           builder: (context, snapshot) {
//                             if(snapshot.hasData) {
//                               return TextTypes.paragraph(
//                                 content: snapshot.data!,
//                               );
//                             }
//                             return const SizedBox();
//                           }
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 _isFollowing
//                   ? _unfollowBtn(
//                       context: context,
//                       followedUser: me,
//                       follower: friend,
//                     )
//                   : _followBtn(me, friend),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
