import 'package:bloc/bloc.dart';
import 'package:frontend/api/auth_service.dart';
import 'package:frontend/api/grpc/grpc_auth_service.dart';
import 'package:frontend/api/grpc/protos/auth.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthService _authService = GRPCAuthService();

  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<LoggingIn>(_onLogin);
    on<SaveToken>(_onSaveToken);
    on<VerifyToken>(_onVerifyToken);
  }

  void _onLogin(LoggingIn event, Emitter<AuthenticationState> emit) async {
    emit(TryLoggingIn());

    LoginResponse resp;
    try {
      //REAL LOGIN
      //resp = await _authService.loginUser(username: event.username, password: event.password);

      //INSTANT LOGIN
      resp = await _authService.loginUser(username: "nomoruyi", password: "password");

      emit(LogInSuccess(userID: resp.userId.toInt(), token: resp.token));
    } on GrpcError catch (e) {
      emit(LoginError(e.code));
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
