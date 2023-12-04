// import '../../../../data/repositories/post_repo.dart';
// import '../../base_usecase.dart';

// class DeletePostCommentParams {
//   final String postId;
//   final String commentId;

//   const DeletePostCommentParams({
//     required this.postId, 
//     required this.commentId,
//   });
// }

// class DeletePostCommentUseCase 
// implements BaseUseCase<Future<void>, DeletePostCommentParams> {
//   final PostRepo _postRepo;

//   DeletePostCommentUseCase(this._postRepo);

//   @override
//   Future<void> call({required DeletePostCommentParams params}) {
//     return _postRepo.deletePostComment(
//       postId: params.postId,
//       commentId: params.commentId,
//     );
//   }
// }