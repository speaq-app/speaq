import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:frontend/api/grpc/grpc_user_service.dart';
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
/*
      on<LoadFollower>(_onLoadFollower);
*/
  }

  void _onLoadFollowerIDs(
      LoadFollowerIDs event, Emitter<FollowerState> emit) async {
    emit(FollowerIDsLoading());
    await Future.delayed(const Duration(seconds: 2)); //removable
    List<int> _follower = await _userService.getFollowerIDs(id: event.userId);
    List<int> _following = await _userService.getFollowingIDs(id: event.userId);
    emit(FollowerIDsLoaded(followerIDs: _follower, followingIDs: _following));
  }

  void _onLoadFollower(LoadFollower event, Emitter<FollowerState> emit) async {
    emit(FollowerIDsLoading());
    await Future.delayed(const Duration(seconds: 2)); //removable
/*
    List<int> _follower = await _userService.getFollower(id: event.followerIDs);
    List<int> _following = await _userService.getFollowing(id: event.followingIDs);

    emit(FollowerIDsLoaded(followerIDs: _follower, followingIDs: _following));
  */
  }
}
