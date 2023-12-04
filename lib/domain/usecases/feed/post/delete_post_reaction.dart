// import '../../../../data/repositories/post_repo.dart';
// import '../../base_usecase.dart';

// class DeletePostReactionParams {
//   final String postId;
//   final String userId;

//   const DeletePostReactionParams({
//     required this.postId,
//     required this.userId,
//   });
// }

// class DeletePostReactionUseCase 
// implements BaseUseCase<Future<void>, DeletePostReactionParams> {
//   final PostRepo _postRepo;

//   DeletePostReactionUseCase(this._postRepo);

//   @override
//   Future<void> call({required DeletePostReactionParams params}) {
//     return _postRepo.deletePostReaction(params.postId, params.userId);
//   }

// }