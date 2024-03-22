import 'package:get_it/get_it.dart';

import 'core/services/location_service.dart';
import 'data/repositories/activity_record_repo.dart';
import 'data/repositories/coordinate_repo.dart';
import 'data/repositories/notification_repo.dart';
import 'data/repositories/photo_repo.dart';
import 'data/repositories/post_repo.dart';
import 'data/sources/firestore/dao/notification_firestore.dart';
import 'data/sources/firestore/dao/post_firestore.dart';
import 'data/sources/firestore/dao/user_firestore.dart';
import 'data/sources/sqlite/dao/activity_record_sqlite.dart';
import 'data/sources/sqlite/dao/coordinate_sqlite.dart';
import 'data/sources/sqlite/dao/photo_sqlite.dart';
import 'data/sources/sqlite/dao/post_sqlite.dart';
import 'data/sources/sqlite/sqlite_service.dart';

final injector = GetIt.instance;

void initializeDependencies() {
  injector.registerLazySingleton(() => LocationService());

  // injector.registerFactory(() => ActivityRecordRepo(injector()));
  // injector.registerFactory(() => CoordinateRepo(injector()));
  // injector.registerFactory(() => PhotoRepo(injector()));
  // injector.registerFactory(() => PostRepo(injector(), injector()));

  // injector.registerFactory(() => UserDao(injector()));
  // injector.registerFactory(() => UserFirestore());

  // injector.registerFactory(() => ActivityRecordSqlite(injector()));
  // injector.registerFactory(() => PhotoSqlite(injector()));
  // injector.registerFactory(() => CoordinateSqlite(injector()));
  // injector.registerFactory(() => PostSqlite(injector()));
  // injector.registerFactory(() => PostFirestore());
  // injector.registerFactory(() => NotificationFirestore());
  // injector.registerFactory(() => UserRepo(injector(), injector()));
  // injector.registerFactory(() => NotificationRepo(injector()));

  // injector.registerFactory(() => AddPostUseCase(injector()));
  // injector.registerFactory(() => GetPostsUseCase(injector()));
  // injector.registerFactory(() => GetPostReactionsUseCase(injector()));
  // injector.registerFactory(() => AddPostReactionUseCase(injector()));
  // injector.registerFactory(() => DeletePostReactionUseCase(injector()));
  // injector.registerFactory(() => GetPostCommentsUseCase(injector()));
  // injector.registerFactory(() => AddPostCommentUseCase(injector()));
  // injector.registerFactory(() => GetPostDetailsUseCase(injector()));
  // injector.registerFactory(() => CountPostCommentsUseCase(injector()));
  // injector.registerFactory(() => CountPostLikesUseCase(injector()));
  // injector.registerFactory(() => CheckPostLikedUseCase(injector()));
  // injector.registerFactory(() => CountPostSubCommentsUseCase(injector()));
  // injector.registerFactory(() => GetMapDetailsUseCase(injector()));
  // injector.registerFactory(() => FollowUserUseCase(injector()));
  // injector.registerFactory(() => UnfollowUserUseCase(injector()));
  // injector.registerFactory(() => FetchFollowersUseCase(injector()));
  // injector.registerFactory(() => FetchNotificationsUseCase(injector()));
  // injector.registerFactory(() => CountUncheckedNotificationsUseCase(injector()));
  
  // injector.registerLazySingleton(() => SqlService.instance.database);
}
