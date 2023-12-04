// import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:iteration_one_fitness_tracker/data/sources/table_attributes.dart';
// import 'package:iteration_one_fitness_tracker/domain/entities/user.dart';
// import 'package:random_name_generator/random_name_generator.dart';

// class UserFirestore {
//   UserFirestore();

//   static final UserFirestore instance = UserFirestore._init();
//   UserFirestore._init();

//   final db = FirebaseFirestore.instance;

//   Future<User> getUserById(String id) async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection(UserFields.container)
//         .doc(id)
//         .get();
//     print("Snapshot data: ${snapshot.data()}");
//     return User.fromFirestore(snapshot);
//   }

//   Future<List<User>> getAllUsers() async {
//     List<User> users = [];
//     final snapshots =
//         await FirebaseFirestore.instance.collection(UserFields.container).get();

//     for (var snapshot in snapshots.docs) {
//       users.add(User.fromSnapshot(snapshot));
//     }
//     return users;
//   }

//   Future<List<User>> getFollowers(String userId) async {
//     final querySnap = await FirebaseFirestore.instance
//       .collection("users/$userId/followers")
//       .get();
    
//     return querySnap.docs.map((q) {
//       final map = q.data();
//       final user = User.empty()
//       ..id = q.id
//       ..username = map["username"]
//       ..firstName = map["firstName"]
//       ..lastName = map["lastName"]
//       ..avatarUrl = map["avatarUrl"];
//       return user;
//     }).toList();
//   }

//   Future<void> addFollower(User followedUser, User follower) {
//     final data = {
//       "userId": follower.id,
//       "username": follower.username,
//       "firstName": follower.firstName,
//       "lastName": follower.lastName,
//       "avatarUrl": follower.avatarUrl,
//     };
//     return FirebaseFirestore.instance
//       .doc("users/${followedUser.id}/followers/${follower.id}")
//       .set(data);
//   }

//   Future<void> deleteFollower(String followedUId, String followerId) {
//     return FirebaseFirestore.instance
//       .doc("users/$followedUId/followers/$followerId")
//       .delete();
//   }

//   Future<User> searchUserById(String keyword) async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection(UserFields.container)
//         .doc(keyword)
//         .get();
//     var data = snapshot.data() as Map<String, dynamic>;
//     data['id'] = snapshot.id;
//     return User.fromMap(data);
//   }

//   Future<List<User>> searchUser(String keyword, String currentUser) async {
//     List<User> users = [];
//     final snapshots = await FirebaseFirestore.instance
//         .collection(UserFields.container)
//         .where("username", isGreaterThanOrEqualTo: keyword)
//         .where("username", isLessThanOrEqualTo: "${keyword}z")
//         .where('username', isNotEqualTo: currentUser)
//         .get();

//     for (var snapshot in snapshots.docs) {
//       users.add(User.fromSnapshot(snapshot));
//     }
//     return users;
//   }

//   void addMockUsers() async {
//     Random r = Random();

//     for (int i = 0; i < 20; i++) {
//       var gender = r.nextInt(2);
//       var randomNames = gender == 1
//           ? RandomNames(Zone.us).manFullName().split(' ')
//           : RandomNames(Zone.us).womanFullName().split(' ');
//       User u = User(
//         username: randomNames.join().toLowerCase(),
//         password: "123456",
//         firstName: randomNames[1],
//         lastName: randomNames[0],
//         dob:
//             "${1990 + r.nextInt(20)}/${r.nextInt(12) + 1}/${r.nextInt(30) + 1}",
//         gender: r.nextInt(2),
//         weight: (r.nextInt(30) + 40).toDouble(),
//         height: (r.nextInt(30) + 150).toDouble(),
//         avatarName: "",
//         avatarUrl: ""
//       );
//       await addUser(u);
//     }
//   }

//   Future addUser(User u) async {
//     await FirebaseFirestore.instance
//         .collection(UserFields.container)
//         .doc(u.id)
//         .set(u.toMap());
//   }

//   Future updateUser(User u, String id) async {
//     await FirebaseFirestore.instance
//         .collection(UserFields.container)
//         .doc(id)
//         .set(u.toMap());
//   }
// }
