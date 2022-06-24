import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/cache/cache_user_service.dart';
import 'package:frontend/api/grpc/grpc_user_service.dart';
import 'package:frontend/api/user_service.dart';
import 'package:frontend/api/model/profile.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserService _userService = GRPCUserService("10.0.2.2", port: 8080);

  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<SaveProfile>(_onSaveProfile);
  }

  void _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    if (!event.fromCache && _userService is CacheUserService) {
      (_userService as CacheUserService).clearProfile(event.userId);
    }
    var _profile = await _userService.getProfile(event.userId);
    emit(ProfileLoaded(profile: _profile));
  }

  void _onSaveProfile(SaveProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileSaving());
    await _userService.updateProfile(id: event.userId, profile: event.profile);
    emit(ProfileSaved());
  }
}
