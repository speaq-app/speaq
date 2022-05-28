part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

class Login extends AuthenticationEvent{
  final String username;
  final String password;
  final bool fromCache;

  Login( {required this.username, required this.password, this.fromCache = true});
}

class SaveToken extends AuthenticationEvent{
  final String token;

  SaveToken({required this.token});
}

class VerifyToken extends AuthenticationEvent{
  final String token;

  VerifyToken({required this.token});
}

