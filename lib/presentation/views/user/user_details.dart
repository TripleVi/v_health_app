// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get_it/get_it.dart';

// import 'package:http/http.dart' as http;

// import '../../../core/utilities/constants.dart';

// class UserDetails extends StatefulWidget {
//   const UserDetails({Key? key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => _UserDetailsState();
// }

// class _UserDetailsState extends State<UserDetails> {
//   bool isShowing = false;
//   FitnessUser.User user = FitnessUser.User.empty();

//   @override
//   void initState() {
//     super.initState();
//     initUser();
//   }

//   void initUser() async {
//     FitnessUser.User u = await GetIt.instance<UserRepo>().isLoggedIn();
//     print(u);
//     setState(() {
//       user = u;
//     });
//   }

//   int _messageCount = 0;
//   String constructFCMPayload(String? token) {
//     _messageCount++;
//     return jsonEncode({
//       'token': token,
//       'data': {
//         'via': 'FlutterFire Cloud Messaging!!!',
//         'count': _messageCount.toString(),
//       },
//       'notification': {
//         'title': 'Hello FlutterFire!',
//         'body': 'This notification (#$_messageCount) was created via FCM!',
//       },
//     });
//   }

//   String? _token;

//   void Send(String notification) async {
//     try {
//       final token = await FirebaseAuth.instance.currentUser!.getIdToken();
//       final fm_token = await FirebaseMessaging.instance.getToken(
//           vapidKey:
//               'BELdHpEXJjNKJBCG3g0kZ-0JMRwJUXYKUv-U6Bi6MbdwttyXeiY95VUxIb66mAr-Ds5s9KCn-Lsigr6kUumnMnY');
//       var response = await http.post(
//         Uri.parse(
//             'https://fcm.googleapis.com/v1/projects/fitness-tracker-f48e6/messages:send'),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode(
//           <String, dynamic>{
//             "token": fm_token,
//             "message": {
//               "data": {},
//               "notification": {
//                 "title": "FCM Message",
//                 "body": "This is an FCM notification message!",
//               }
//             }
//           },
//         ),
//       );
//       print('done ${response.body}');
//     } catch (e) {
//       print("error push notification");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//         child: Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const CircleAvatar(
//                 radius: 50,
//                 backgroundImage: NetworkImage(
//                     'https://news.artnet.com/app/news-upload/2019/01/Cat-Photog-Feat-256x256.jpg'),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 15.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 5.0),
//                       child: TextTypes.heading_1(
//                           content: '${user.lastName} ${user.firstName}'),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 5.0),
//                       child: GestureDetector(
//                         onTap: () {
//                           Clipboard.setData(ClipboardData(text: user.id));
//                           ScaffoldMessenger.of(context)
//                               .showSnackBar(const SnackBar(
//                             content: Text("Your ID has been copied!"),
//                           ));
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                               color: Constants.primaryColor,
//                               borderRadius: BorderRadius.circular(25)),
//                           child: Padding(
//                             padding: const EdgeInsets.fromLTRB(15.0, 5, 15, 8),
//                             child: TextTypes.paragraph(
//                                 content: "Copy ID", color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 20.0),
//             child: ElevatedButton(
//                 onPressed: () async {
//                   ReportService.instance.addMockHourlyReport('2023/04/07', 151);
//                   print('Add mock data');
//                 },
//                 child: const Text('Test')),
//           ),
//           Padding(
//               padding: const EdgeInsets.only(top: 5),
//               child: TextButton(
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => Registration(
//                                 isEdit: 2,
//                                 u: user,
//                                 curr_index: 1,
//                               )));
//                 },
//                 child: const Text(
//                   'Change Password',
//                   style:
//                       TextStyle(fontFamily: Constants.fontFace, fontSize: 16),
//                 ),
//               )),
//           Padding(
//               padding: const EdgeInsets.only(top: 5),
//               child: TextButton(
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => Registration(
//                                 isEdit: 1,
//                                 u: user,
//                                 curr_index: 1,
//                               )));
//                 },
//                 child: const Text(
//                   'Edit Profile',
//                   style:
//                       TextStyle(fontFamily: Constants.fontFace, fontSize: 16),
//                 ),
//               )),
//           TextButton(
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
//             onPressed: () async {
//               bool res = await GetIt.instance<UserRepo>().clearDatabase();
//               final dir = await MyUtils.getAppDirectory();
//               dir.deleteSync(recursive: true);
//               final result = dir.existsSync();
//               print("Dir exists: $result");
//               if (!mounted) return;
//               Navigator.of(context, rootNavigator: true).pushReplacement(
//                   MaterialPageRoute(
//                       builder: (BuildContext context) => const Login()));
//             },
//             child: const Text(
//               'Log Out',
//               style: TextStyle(
//                   fontFamily: Constants.fontFace,
//                   fontSize: 16,
//                   color: Colors.black),
//             ),
//           ),
//         ],
//       ),
//     ));
//   }

//   List<Widget> get appBar {
//     return <Widget>[
//       IconButton(
//         tooltip: 'Open navigation menu',
//         icon: const Icon(Icons.menu),
//         onPressed: () {},
//       ),
//       IconButton(
//         tooltip: 'Search',
//         icon: const Icon(Icons.search),
//         onPressed: () {},
//       ),
//       IconButton(
//         tooltip: 'Favorite',
//         icon: const Icon(Icons.favorite),
//         onPressed: () {},
//       ),
//     ];
//   }
// }
