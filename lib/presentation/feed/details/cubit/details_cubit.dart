import "package:flutter_bloc/flutter_bloc.dart";
import "package:matrix2d/matrix2d.dart";

import "../../../../data/sources/api/post_service.dart";
import "../../../../domain/entities/post.dart";

part "details_state.dart";

class DetailsCubit extends Cubit<DetailsState> {
  final Post post;

  DetailsCubit(this.post) : super(const DetailsLoading()) {
    _fetchData();
  }

  Future<void> _fetchData() async {
    final service = PostService();
    final details = await service.fetchPostDetails(post.id);
    if(details == null) {
      return emit(const DetailsError());
    }
    final times = [0], speeds = [0.0], paces = [0.0];
    post.record.coordinates = details.record.coordinates;
    post.record.photos = details.record.photos;
    for (var d in details.record.data) {
      times.add(d.time);
      speeds.add(d.speed);
      paces.add(1/d.speed);
    }
    times.add(times.last+1);
    speeds.add(0.0);
    paces.add(0.0);
    emit(DetailsLoaded(
      post: post,
      times: times,
      speeds: speeds,
      avgSpeed: speeds.sum/(speeds.length-2),
      paces: paces,
      avgPace: paces.sum/(paces.length-2)
    ));
  }
}