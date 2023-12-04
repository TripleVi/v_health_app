import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as ta;

import '../../../../core/services/location_service.dart';
import '../../../../data/sources/api/post_service.dart';
import '../../../../domain/entities/post.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final Post _post;

  PostCubit(this._post) : super(const PostLoading()) {
    _processPost();
  }

  Future<void> _processPost() async {
    final service = PostService();
    final map = await service.countLikes(_post.id);
    final comments = await service.countComments(_post.id);
    var address = "";
    try {
      final geoResponse = await LocationService.getAddressFromPosition(
        latitude: _post.latitude!,
        longitude: _post.longitude!,
      );
      address = "${geoResponse.administrativeArea}, ${geoResponse.country}";
    } on PlatformException catch (e) {
      print(e);
    }
    final txtDate = ta.format(_post.createdDate, locale: "en");
    final record = _post.record;
    final rDuration = record.endDate.difference(record.startDate);
    String rTime = "";
    final hours = rDuration.inHours;
    final minutes = rDuration.inMinutes - rDuration.inHours * 60;
    if(rDuration.inHours > 0) {
      rTime = "$hours h";
    }
    if(rDuration.inMinutes > 0) {
      rTime = "${rTime.isEmpty ? "$rTime " : ""}$minutes m";
    }
    if(rDuration.inSeconds <= 59) {
      rTime = "${rDuration.inSeconds} s";
    }

    emit(PostLoaded(
      post: _post,
      isLiked: map["isLiked"],
      likes: map["likes"],
      comments: comments,
      txtDate: txtDate,
      recordTime: rTime,
      address: address,
    ));
  }

  Future<void> handleLikePost() async {
    // final user = await _userFuture;
    // final curtState = state as PostLoaded;
    // try {
    //   if(curtState.isLiked) {
    //     final deletePostReactionUseCase = GetIt.instance<DeletePostReactionUseCase>();
    //     await deletePostReactionUseCase(
    //       params: DeletePostReactionParams(
    //         postId: _post.id,
    //         userId: user.id,
    //       ),
    //     );
    //     return emit(PostLoaded(
    //       post: _post,
    //       isLiked: false,
    //       likes: curtState.likes-1,
    //       comments: curtState.comments,
    //       createdAt: curtState.createdAt,
    //       recordTime: curtState.recordTime,
    //       address: curtState.address,
    //     ));
    //   }
    //   final addPostReactionUseCase = GetIt.instance<AddPostReactionUseCase>();
    //   await addPostReactionUseCase(
    //     params: AddPostReactionParams(
    //       postId: _post.id, 
    //       reaction: Reaction(
    //         userId: user.id, 
    //         type: ReactionType.like.index, 
    //         firstName: user.firstName, 
    //         lastName: user.lastName,
    //         username: user.username,
    //         avatarUrl: user.avatarUrl,
    //       ),
    //     ),
    //   );
    //   emit(PostLoaded(
    //     post: _post,
    //     isLiked: true,
    //     likes: curtState.likes+1,
    //     comments: curtState.comments,
    //     createdAt: curtState.createdAt,
    //     recordTime: curtState.recordTime,
    //     address: curtState.address,
    //   ));
    // } catch (e) {
    //   rethrow;
    // }
  }

}