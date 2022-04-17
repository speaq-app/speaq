part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class SaveProfile extends ProfileEvent {
  final int id;
  final String name;
  final String username;
  final String description;
  final String website;

  SaveProfile({
    required this.id,
    required this.name,
    required this.username,
    required this.description,
    required this.website,
  });
}
