// import '../../../data/repositories/user_repo.dart';
// import '../base_usecase.dart';

// class UnfollowUserParams {
//   final String followedUId;
//   final String followerId;

//   const UnfollowUserParams(this.followedUId, this.followerId);
// }

// class UnfollowUserUseCase implements BaseUseCase<void, UnfollowUserParams> {
//   final UserRepo _userRepo;
//   UnfollowUserUseCase(this._userRepo);
  
//   @override
//   Future<void> call({required UnfollowUserParams params}) {
//     return _userRepo.deleteFollower(params.followedUId, params.followerId);
//   }
// }