import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:frontend/api/cache/cache_user_service.dart';
import 'package:frontend/api/grpc/grpc_user_service.dart';
import 'package:frontend/api/grpc/protos/user.pb.dart';
import 'package:frontend/api/user_service.dart';
import 'package:grpc/grpc.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserService _userService = GRPCUserService();

  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<LoggingIn>(_onLogin);
    on<SaveToken>(_onSaveToken);
    on<VerifyToken>(_onVerifyToken);
  }

  void _onLogin(LoggingIn event, Emitter<AuthenticationState> emit) async {
    emit(TryLoggingIn());
    LoginResponse resp;

    try {
      print("username BloC: " + event.username);
      print("password BloC: " + event.password);

      //REAL LOGIN
      //resp = await _userService.login(username: event.username, password: event.password);

      resp = await _userService.login(username: "nomoruyi", password: "OpenToWork");

      print("user id BloC: ${resp.userId}");
      print("token BloC: " + resp.token);
      emit(LogInSuccess(userID: resp.userId.toInt(), token: resp.token));


      print("Login Success !");
    } on GrpcError catch (err)  {
      print("Login Failed GRPC ERROR!:" + err.toString());
      print("Login Failed GRPC ERROR!:" + err.runtimeType.toString());

      emit(LogInFail(message: "ERROR: ${err.message}"));
    }
    catch (err) {
      print("Login Failed ERROR!:" + err.toString());
      print("Login Failed ERROR!:" + err.runtimeType.toString());

      emit(LogInFail(message: err.toString()));

    }
  }
  void _onSaveToken(SaveToken event, Emitter<AuthenticationState> emit) async {
    emit(TokenSaving());

    emit(TokenSaved());

  }
  void _onVerifyToken(VerifyToken event, Emitter<AuthenticationState> emit) async {
    emit(TokenLoading());

    emit(TokenLoaded());

  }
}
