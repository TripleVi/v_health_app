// import 'package:sqflite/sqflite.dart';

// import '../../domain/entities/user.dart';
// import '../sources/firestore/dao/user_firestore.dart';
// import '../sources/sqlite/sqlite_service.dart';
// import '../sources/table_attributes.dart';
// import '../sources/sqlite/dao/user_dao.dart';

// class UserRepo {
//   final UserDao _userDao;
//   final UserFirestore _userFirestore;

//   UserRepo(this._userDao, this._userFirestore);

//   Future<bool> updateUserLocal(User u) async {
//     return await _userDao.updateUser(u);
//   }

//   // Future<List<User>> getAllFriends() async {
//   //   List<User> friends = [];
//   //   final db = await SqlService.instance.database;
//   //   final session = await db.query(UserFields.container);

//   //   User user = User.fromMap(session[0]);

//   //   if (user.friends != null) {
//   //     for (String s in user.friends!) {
//   //       User u = await UserFirestore.instance.getUserById(s);
//   //       friends.add(u);
//   //     }
//   //   }

//   //   return friends;
//   // }

//   Future<List<User>> getFollowers(String userId) {
//     return _userFirestore.getFollowers(userId);
//   }

//   Future<User> getUser() async {
//     var user = await _userDao.getUser();
//     var firestoreUser = await UserFirestore.instance.getUserById(user.id);
//     return firestoreUser;
//   }

//   Future<User> getUserSession() {
//     return _userDao.getUser();
//   }

//   Future createSession(User u) async {
//     final db = await SqlService.instance.database;
//     db.insert(UserFields.container, u.toMap(),
//         conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   Future<User> isLoggedIn() async {
//     final db = await SqlService.instance.database;
//     final result = await db.query(UserFields.container);
//     if (result.isNotEmpty) {
//       return User.fromMap(result.first);
//     } else {
//       return User.empty();
//     }
//   }

//   Future destroySession() async {
//     final db = await SqlService.instance.database;
//     await db.delete(UserFields.container);
//   }

//   Future<void> addFollower(User followedUser, User follower) {
//     return _userFirestore.addFollower(followedUser, follower);
//   }

//   Future<void> deleteFollower(String followedUId, String followerId) {
//     return _userFirestore.deleteFollower(followedUId, followerId);
//   }

//   // Future fetchFeed(String user) async {
//   //   User? user = await _userDao.getUser();
//   //   List posts = [];
//   //   switch (user.friends.runtimeType) {
//   //     case String:
//   //       break;
//   //     case List:
//   //       for (String friendId in user.friends) {}
//   //       break;
//   //     default:
//   //       break;
//   //   }
//   //   return posts;
//   // }

//   Future clearDatabase() async {
//     try {
//       final db = await SqlService.instance.database;
//       db.rawQuery('delete from ${UserFields.container}');
//       return true;
//     } catch (e) {
//       return false;
//     }
//   }

//   Future<bool> validPassword(String password) async {
//     var user = await _userDao.getUser();
//     return user.password == password;
//   }
// }
