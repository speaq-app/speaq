part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent {}

class RegisterUser extends RegisterEvent {
  final String username;
  final String password;

  RegisterUser({required this.username, required this.password});
}
