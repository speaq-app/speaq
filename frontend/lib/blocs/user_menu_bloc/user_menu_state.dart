part of 'user_menu_bloc.dart';

@immutable
abstract class UserMenuState {}

class UserMenuInitial extends UserMenuState {}

class UserMenuLoading extends UserMenuState {}

class UserMenuWithoutPictureLoaded extends UserMenuState {
  final Profile profile;

  UserMenuWithoutPictureLoaded(this.profile);
}

class UserMenuLoaded extends UserMenuState {
  final Resource resource;

  UserMenuLoaded(this.resource);
}
