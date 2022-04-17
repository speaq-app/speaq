part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class SaveProfile extends ProfileEvent {
  final User user;

  SaveProfile({
    required this.user
  });
}
