part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

//cur
class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Profile profile;

  ProfileLoaded({
    required this.profile,
  });
}

class ProfileSaving extends ProfileState {}

class ProfileSaved extends ProfileState {}
