import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/grpc/grpc_user_service.dart';
import 'package:frontend/api/user_service.dart';
import 'package:frontend/pages/profile/model/profile.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserService _userService = GRPCUserService();

  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<SaveProfile>(_onSaveProfile);
  }

  void _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    await Future.delayed(const Duration(seconds: 2)); //removeable

    var _profile = await _userService.getProfile(event.userId);
    emit(ProfileLoaded(profile: _profile));
  }

  void _onSaveProfile(SaveProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileSaving());
    await _userService.updateProfile(
        id: event.userId, userProfile: event.profile);
    await Future.delayed(const Duration(seconds: 2)); //removeable

    emit(ProfileSaved());
  }
}
