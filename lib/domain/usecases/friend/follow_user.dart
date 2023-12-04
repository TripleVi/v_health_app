// import '../../../data/repositories/user_repo.dart';
// import '../../entities/user.dart';
// import '../base_usecase.dart';

// class FollowUserParams {
//   final User followedUser;
//   final User follower;

//   const FollowUserParams(this.followedUser, this.follower);
// }

// class FollowUserUseCase implements BaseUseCase<void, FollowUserParams> {
//   final UserRepo _userRepo;
//   FollowUserUseCase(this._userRepo);
  
//   @override
//   Future<void> call({required FollowUserParams params}) {
//     return _userRepo.addFollower(params.followedUser, params.follower);
//   }
// }