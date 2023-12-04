// import '../../../../data/repositories/post_repo.dart';
// import '../../../entities/reaction.dart';
// import '../../base_usecase.dart';

// class AddPostReactionParams {
//   final String postId;
//   final Reaction reaction;

//   AddPostReactionParams({
//     required this.postId, 
//     required this.reaction,
//   });
// }

// class AddPostReactionUseCase 
// implements BaseUseCase<Future<void>, AddPostReactionParams> {
//   final PostRepo _postRepo;

//   AddPostReactionUseCase(this._postRepo);

//   @override
//   Future<void> call({required AddPostReactionParams params}) {
//     return _postRepo.insertPostReaction(params.postId, params.reaction);
//   }
  
// }