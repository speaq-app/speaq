import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:frontend/api/grpc/grpc_user_service.dart';
import 'package:frontend/api/grpc/protos/user.pbgrpc.dart';
import 'package:frontend/api/model/user.dart';
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

    List<int> _followerIDs = await _userService.getFollowerIDs(id: event.userId);
    List<int> _followingIDs = await _userService.getFollowingIDs(id: event.userId);

    emit(FollowerIDsLoaded(followerIDs: _followerIDs, followingIDs: _followingIDs));
  }

  void _onLoadFollower(LoadFollower event, Emitter<FollowerState> emit) async {
    emit(FollowerLoading());

    List<FollowUser> _follower = await _userService.getFollower(ids: event.followerIDs);
    List<FollowUser> _following = await _userService.getFollowing(ids: event.followingIDs);

    emit(FollowerLoaded(follower: _follower, following: _following));
  }
}
