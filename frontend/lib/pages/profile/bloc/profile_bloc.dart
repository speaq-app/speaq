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
        //Events
    on<LoadProfile>(_onLoadProfile);
    on<SaveProfile>(_onSaveProfile);
  }

  Future<void> _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading()); //State (Shimmer)

    var _profile = await _userService.getProfile(event.userId);
    emit(ProfileLoaded(profile: _profile)); //State
  }

  void _onSaveProfile(SaveProfile event, Emitter<ProfileState> emit) {
    emit(ProfileSaving());
  }
}
