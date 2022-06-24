part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {
  final int userId;
  final bool fromCache;

  LoadProfile({this.userId = 0, this.fromCache = true});
}

class SaveProfile extends ProfileEvent {
  final int userId;
  final Profile profile;

  SaveProfile({
    required this.userId,
    required this.profile,
  });
}
