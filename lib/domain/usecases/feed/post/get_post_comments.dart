// import '../../../../data/repositories/post_repo.dart';
// import '../../../entities/comment.dart';
// import '../../base_usecase.dart';

// class GetPostCommentsParams {
//   final String postId;
//   final String? parentId;
//   final int limit;

//   GetPostCommentsParams({
//     required this.postId, 
//     this.parentId,
//     required this.limit,
//   });
// }

// class GetPostCommentsUseCase 
// implements BaseUseCase<Stream<List<Comment>>, GetPostCommentsParams> {
//   final PostRepo _postRepo;

//   const GetPostCommentsUseCase(this._postRepo);

//   @override
//   Stream<List<Comment>> call({required GetPostCommentsParams params}) {
//     return _postRepo.getPostComments(
//       postId: params.postId,
//       parentId: params.parentId,
//       limit: params.limit,
//     );
//   }
// }
