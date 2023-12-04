import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../domain/entities/post.dart';
import '../../../../domain/usecases/feed/details/get_post_details.dart';

part 'details_state.dart';

class DetailsCubit extends Cubit<DetailsState> {
  final String _postId;

  DetailsCubit(this._postId) : super(const DetailsLoading()) {
    // final getPostDetailsUseCase = GetIt.instance<GetPostDetailsUseCase>();
    // getPostDetailsUseCase(params: _postId).then((post) {
    //   emit(DetailsLoaded(post));
    // });
  }
}