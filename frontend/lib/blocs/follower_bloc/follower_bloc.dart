import 'package:bloc/bloc.dart';
import 'package:frontend/api/grpc/grpc_user_service.dart';
import 'package:frontend/api/grpc/protos/user.pbgrpc.dart';
import 'package:frontend/api/user_service.dart';
import 'package:meta/meta.dart';

part 'follower_event.dart';

part 'follower_state.dart';

class FollowerBloc extends Bloc<FollowerEvent, FollowerState> {
  final UserService _userService = GRPCUserService("10.0.2.2", port: 8080);

  FollowerBloc() : super(FollowerInitial()) {
    on<LoadFollowerIDs>(_onLoadFollowerIDs);
    on<LoadFollower>(_onLoadFollower);
    on<CheckIfFollowing>(_onCheckIfFollowing);
    on<FollowUnfollow>(_onFollowUnfollow);
  }

  void _onLoadFollowerIDs(LoadFollowerIDs event, Emitter<FollowerState> emit) async {
    emit(FollowerIDsLoading());
    List<int> followerIDs = await _userService.getFollowerIDs(id: event.userId);
    List<int> followingIDs = await _userService.getFollowingIDs(id: event.userId);
    emit(FollowerIDsLoaded(followerIDs: followerIDs, followingIDs: followingIDs));
  }

  void _onLoadFollower(LoadFollower event, Emitter<FollowerState> emit) async {
    emit(FollowerLoading());
    List<FollowUser> follower = await _userService.getFollower(ids: event.followerIDs);
    List<FollowUser> following = await _userService.getFollowing(ids: event.followingIDs);
    emit(FollowerLoaded(follower: follower, following: following));
  }

  void _onFollowUnfollow(FollowUnfollow event, Emitter<FollowerState> emit) async {
    emit(FollowUnfollowLoading());
    bool isFollowing = await _userService.followUnfollow(userID: event.userID, followerID: event.followerID);

    print("exec: _onFollowUnfollow bloc - $isFollowing");

    emit(FollowUnfollowLoaded(isFollowing: isFollowing));
  }

  void _onCheckIfFollowing(CheckIfFollowing event, Emitter<FollowerState> emit) async {
    bool isFollowing = await _userService.checkIfFollowing(userID: event.userID, followerID: event.followerID);

    emit(CheckIfFollowingLoaded(isFollowing: isFollowing));
  }
}
