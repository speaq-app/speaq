part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String token;

  LoginSuccess({
    required this.token,
  });
}

class LoginError extends LoginState {
  final int code;

  LoginError({
    required this.code,
  });
}
