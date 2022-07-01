import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/cache/cache_user_service.dart';
import 'package:frontend/api/grpc/grpc_user_service.dart';
import 'package:frontend/api/user_service.dart';
import 'package:frontend/api/model/profile.dart';
import 'package:frontend/utils/backend_utils.dart';
import 'package:grpc/grpc.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserService _userService =
      GRPCUserService(BackendUtils.createClientChannel());

  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<SaveProfile>(_onSaveProfile);
  }

  void _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    if (!event.fromCache && _userService is CacheUserService) {
      (_userService as CacheUserService).clearProfile(event.userId);
    }

    try {
      var profile = await _userService.getProfile(event.userId);
      emit(ProfileLoaded(profile: profile));
    } on GrpcError catch (_) {
      emit(ProfileError());
    }
  }

  void _onSaveProfile(SaveProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileSaving());
    await _userService.updateProfile(id: event.userId, profile: event.profile);
    emit(ProfileSaved());
  }
}
