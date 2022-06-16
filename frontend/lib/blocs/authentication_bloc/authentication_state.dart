part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class TokenLoading extends AuthenticationState {}

class TokenLoaded extends AuthenticationState {}

class TryLoggingIn extends AuthenticationState {}

class LogInSuccess extends AuthenticationState {
  final int userID;
  final String token;

  LogInSuccess({required this.userID, required this.token});

}

class LogInFail extends AuthenticationState {
final String message;

  LogInFail({required this.message});

}

class TokenSaving extends AuthenticationState {}

class TokenSaved extends AuthenticationState {}
