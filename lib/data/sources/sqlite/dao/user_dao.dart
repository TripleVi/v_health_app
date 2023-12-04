// import 'package:sqflite/sqflite.dart';

// import '../../../../domain/entities/user.dart';
// import '../../table_attributes.dart';

// class UserDao {
//   final Future<Database> _dbFuture;

//   UserDao(this._dbFuture);

//   Future<bool> insertUser(User user) async {
//     final db = await _dbFuture;
//     await db.insert(UserFields.container, user.toMap());
//     return true;
//   }

//   Future<User> getUser() async {
//     final db = await _dbFuture;
//     final maps = await db.query(UserFields.container);
//     if(maps.length != 1) {
//       throw Exception("User does not exist");
//     }
//     return User.fromMap(maps.first);
//   }

//   Future<bool> deleteUser() async {
//     final db = await _dbFuture;
//     try {
//       final changes = await db.delete(UserFields.container, where: null);
//       return changes > 0;
//     } catch (e) {
//       return false;
//     }
//   }

//   Future<bool> updateUser(User user) async {
//     final db = await _dbFuture;
//     try {
//       final changes = await db.update(
//         UserFields.container,
//         user.toMap(),
//         where: "${UserFields.id} = ?",
//         whereArgs: [user.id],
//       );
//       return changes > 0;
//     } catch (e) {
//       return false;
//     }
//   }

  
// }
