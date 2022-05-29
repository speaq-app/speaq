import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:frontend/api/cache/cache_user_service.dart';
import 'package:frontend/api/grpc/grpc_user_service.dart';
import 'package:frontend/api/grpc/protos/user.pb.dart';
import 'package:frontend/api/user_service.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserService _userService = CacheUserService(GRPCUserService());

  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<Login>(_onLogin);
    on<SaveToken>(_onSaveToken);
    on<VerifyToken>(_onVerifyToken);
  }

  void _onLogin(Login event, Emitter<AuthenticationState> emit) async {
    emit(TryLoggingIn());
    LoginResponse resp;

    try {
      if(event.fromCache) {
        resp = await (_userService as GRPCUserService).login(username: event.username, password: event.password);
      } else {
        resp = await (_userService as CacheUserService).login(username: event.username, password: event.password);
      }
      emit(LogInSuccess());
    } on Error {
     emit(LogInFail());
    }
  }
  void _onSaveToken(SaveToken event, Emitter<AuthenticationState> emit) async {
    emit(TryLoggingIn());
  }
  void _onVerifyToken(VerifyToken event, Emitter<AuthenticationState> emit) async {
    emit(TokenLoading());
  }
}
