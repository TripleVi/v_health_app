// import 'dart:io' as io;
// import 'dart:typed_data';

// import 'package:firebase_storage/firebase_storage.dart';

// class StorageService{
//   StorageService._();

//   static String join(String part1, [
//     String? part2,
//     String? part3,
//     String? part4,
//   ]) {
//     final parts = <String?>[part1, part2, part3, part4];
//     return parts.where((p) => p != null && p.isNotEmpty).join("/");
//   }

//   static UploadTask uploadFile({
//     required String path,
//     required io.File file,
//   }) {
//     final metadata = SettableMetadata(
//       contentType: "image/jpeg",
//     );
//     return FirebaseStorage.instance
//       .ref()
//       .child(path)
//       .putFile(file, metadata);
//   }

//   static UploadTask uploadFileBytes({
//     required Uint8List bytes,
//     required String path,
//   }) {
//     final metadata = SettableMetadata(
//       contentType: "image/jpeg",
//     );
//     return FirebaseStorage.instance
//       .ref()
//       .child(path)
//       .putData(bytes, metadata);
//   }

//   static DownloadTask downloadFile({
//     required io.File file,
//     required String path,
//   }) {
//     if(file.existsSync()) {
//       throw Exception("File already exists at ${file.uri}");
//     }
//     if(!file.parent.existsSync()) {
//       throw Exception("Parent directory does not exist at ${file.uri}");
//     }
//     return FirebaseStorage.instance
//       .ref()
//       .child(path)
//       .writeToFile(file);
//   }

//   static Future<Uint8List?> downloadFileBytes(String path) async {
//     try {
//       return FirebaseStorage.instance
//         .ref()
//         .child(path)
//         .getData();
//     } on FirebaseException catch (e) {
//       rethrow;
//     }
//   }

//   static Future<String> getFileUrl(String path) async {
//     return FirebaseStorage.instance
//       .ref()
//       .child(path)
//       .getDownloadURL();
//   }
// }