part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class TokenLoading extends LoginState {}

class TokenLoaded extends LoginState {}

class LoginSuccess extends LoginState {
  final int userID;
  final String token;

  LoginSuccess({required this.userID, required this.token});
}

class LoginError extends LoginState {
  final int code;

  LoginError(this.code);
}
