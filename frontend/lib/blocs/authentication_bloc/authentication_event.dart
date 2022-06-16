part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

class LoggingIn extends AuthenticationEvent {
  final String username;
  final String password;

  LoggingIn({required this.username, required this.password});
}

class SaveToken extends AuthenticationEvent {
  final String token;

  SaveToken({required this.token});
}

class VerifyToken extends AuthenticationEvent {
  final String token;

  VerifyToken({required this.token});
}
