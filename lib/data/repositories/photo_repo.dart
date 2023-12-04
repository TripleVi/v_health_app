import 'dart:async';

import '../../domain/entities/photo.dart';
import '../sources/sqlite/dao/photo_sqlite.dart';

class PhotoRepo {
  final PhotoSqlite _photoSqlite;

  PhotoRepo(this._photoSqlite);

  // Future<void> addPhotos(List<Photo> photos) {
  //   return _photoSqlite.insertPhotos(photos);
  // }

  // Future<List<Photo>> getPhotos(String activityRecordId) {
  //   return _photoSqlite.getPhotos(activityRecordId);
  // }
   
}