// import '../../../../data/repositories/post_repo.dart';
// import '../../base_usecase.dart';

// class CheckPostLikedParams {
//   String postId;
//   String userId;

//   CheckPostLikedParams({
//     required this.postId,
//     required this.userId,
//   });
// }

// class CheckPostLikedUseCase 
// implements BaseUseCase<Future<bool>, CheckPostLikedParams> {
//   final PostRepo _postRepo;

//   const CheckPostLikedUseCase(this._postRepo);

//   @override
//   Future<bool> call({required CheckPostLikedParams params}) {
//     return _postRepo.isPostLiked(
//       postId: params.postId,
//       userId: params.userId,
//     );
//   }
// }