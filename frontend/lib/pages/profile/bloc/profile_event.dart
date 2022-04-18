part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {
  final int userId;

  LoadProfile({required this.userId});
}

class SaveProfile extends ProfileEvent {
  final int userId;
  final Profile profile;

  SaveProfile({
    required this.userId,
    required this.profile,
  });
}