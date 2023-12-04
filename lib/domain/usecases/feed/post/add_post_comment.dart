// import '../../../../data/repositories/post_repo.dart';
// import '../../../entities/comment.dart';
// import '../../base_usecase.dart';

// class AddPostCommentParams {
//   final String postId;
//   final Comment comment;

//   AddPostCommentParams(this.postId, this.comment);
// }

// class AddPostCommentUseCase 
// implements BaseUseCase<Future<void>, AddPostCommentParams> {
//   final PostRepo _postRepo;

//   AddPostCommentUseCase(this._postRepo);

//   @override
//   Future<void> call({required AddPostCommentParams params}) {
//     return _postRepo.insertPostComment(params.postId, params.comment);
//   }
  
// }