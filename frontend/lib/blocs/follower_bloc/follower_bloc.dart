import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:frontend/api/grpc/grpc_user_service.dart';
import 'package:frontend/api/user_service.dart';
import 'package:meta/meta.dart';

part 'follower_event.dart';

part 'follower_state.dart';

class FollowerBloc extends Bloc<FollowerEvent, FollowerState> {
  final UserService _userService = GRPCUserService();

  FollowerBloc() : super(FollowerInitial()) {
    on<FollowerEvent>((event, emit) {
      on<LoadFollower>(_onLoadFollower);

    });
  }

  void _onLoadFollower(LoadFollower event, Emitter<FollowerState> emit) async {
    emit(FollowerLoading());
    await Future.delayed(const Duration(seconds: 2)); //removeable
    var _follower = await _userService.getFollower(id: event.userId);
    emit(FollowerLoaded(follower: _follower.length));
  }
}
