part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class TokenLoading extends AuthenticationState {

}

class TokenLoaded extends AuthenticationState {

}

class LoggingIn extends AuthenticationState {

}

class LogInSuccess extends AuthenticationState {

}

class LogInFail extends AuthenticationState {

}

class TokenSaving extends AuthenticationState {

}

class TokenSaved extends AuthenticationState {

}
