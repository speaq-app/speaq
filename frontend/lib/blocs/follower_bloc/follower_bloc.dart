import 'package:bloc/bloc.dart';
import 'package:frontend/api/grpc/grpc_user_service.dart';
import 'package:frontend/api/grpc/protos/user.pbgrpc.dart';
import 'package:frontend/api/user_service.dart';
import 'package:meta/meta.dart';

part 'follower_event.dart';

part 'follower_state.dart';

class FollowerBloc extends Bloc<FollowerEvent, FollowerState> {
  final UserService _userService = GRPCUserService();

  FollowerBloc() : super(FollowerInitial()) {
/*
      on<FollowerEvent>(_onLoadFollower);
*/
    on<LoadFollowerIDs>(_onLoadFollowerIDs);
    on<LoadFollower>(_onLoadFollower);
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
}
