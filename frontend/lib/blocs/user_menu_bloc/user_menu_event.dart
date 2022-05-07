part of 'user_menu_bloc.dart';

@immutable
abstract class UserMenuEvent {}

class LoadUserMenu extends UserMenuEvent {
  final int userId;

  LoadUserMenu({required this.userId});
}
