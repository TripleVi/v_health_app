import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/sources/api/post_service.dart';
import '../../../../domain/entities/post.dart';

part 'details_state.dart';

class DetailsCubit extends Cubit<DetailsState> {
  final Post post;

  DetailsCubit(this.post) : super(const DetailsLoading()) {
    _fetchData();
  }

  Future<void> _fetchData() async {
    final service = PostService();
    emit(DetailsLoaded(post));
  }
}