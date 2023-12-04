// import '../../../../data/repositories/post_repo.dart';
// import '../../base_usecase.dart';

// class CountPostSubCommentsParams {
//   final String postId;
//   final String? parentId;

//   const CountPostSubCommentsParams({
//     required this.postId,
//     this.parentId,
//   });
// }

// class CountPostSubCommentsUseCase 
// implements BaseUseCase<Future<int>, CountPostSubCommentsParams> {
//   final PostRepo _postRepo;

//   const CountPostSubCommentsUseCase(this._postRepo);

//   @override
//   Future<int> call({required CountPostSubCommentsParams params}) {
//     return _postRepo.countPostSubComments(
//       postId: params.postId,
//       parentId: params.parentId,
//     );
//   }
// }