import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/shared_pref_service.dart';
import '../../../../data/sources/api/post_service.dart';
import '../../../../domain/entities/post.dart';

part 'activity_state.dart';

class ActivityCubit extends Cubit<ActivityState> {
  final String uid;

  ActivityCubit(this.uid) : super(ActivityLoading()) {
    fetchData();
  }

  Future<void> fetchData() async {
    final service = PostService();
    final posts = await service.fetchPosts(uid);
    print(posts);
    final user = await SharedPrefService.getCurrentUser();
    emit(ActivityLoaded(posts: posts, other: uid != user.uid));
  }
}
