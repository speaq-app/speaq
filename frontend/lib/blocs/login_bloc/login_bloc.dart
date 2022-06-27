import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/auth_service.dart';
import 'package:frontend/api/grpc/grpc_auth_service.dart';
import 'package:frontend/utils/backend_utils.dart';
import 'package:frontend/utils/token_utils.dart';
import 'package:grpc/grpc.dart';


part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService _authService = GRPCAuthService(
    BackendUtils.getHost(),
    port: BackendUtils.getPort(),
  );

  LoginBloc() : super(LoginInitial()) {
    on<Login>(_onLogin);
  }

  void _onLogin(Login event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      String token = await _authService.login(
        username: event.username,
        password: event.password,
      );
      await TokenUtils.setToken(token);
      emit(LoginSuccess(token: token));
    } on GrpcError catch (e) {
      print(e.message);
      emit(LoginError(code: e.code));
    }
  }
}
