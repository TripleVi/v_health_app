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
import 'domain/usecases/activity_tracking/add_post.dart';
import 'domain/usecases/feed/post/add_post_comment.dart';
import 'domain/usecases/feed/post/add_post_reaction.dart';
import 'domain/usecases/feed/post/check_post_liked.dart';
import 'domain/usecases/feed/post/count_post_comments.dart';
import 'domain/usecases/feed/post/count_post_likes.dart';
import 'domain/usecases/feed/post/count_post_sub_comments.dart';
import 'domain/usecases/feed/post/delete_post_reaction.dart';
import 'domain/usecases/feed/details/get_post_details.dart';
import 'domain/usecases/feed/post/get_post_comments.dart';
import 'domain/usecases/feed/post/get_post_reactions.dart';
import 'domain/usecases/feed/get_posts.dart';
import 'domain/usecases/feed/map/get_map_details.dart';
import 'domain/usecases/friend/fetch_followers.dart';
import 'domain/usecases/friend/follow_user.dart';
import 'domain/usecases/friend/unfollow_user.dart';
import 'domain/usecases/notification/count_unchecked_notification.dart';
import 'domain/usecases/notification/fetch_notifications.dart';

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
