import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:frontend/pages/profile/model/user.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) {
      if(event is ProfileInitial){
        log("initial");
      }
      if(event is ProfileLoading){
        log("loading");
      }
      if(event is ProfileLoading){
        log("loaded");
      }
    });
  }
}
