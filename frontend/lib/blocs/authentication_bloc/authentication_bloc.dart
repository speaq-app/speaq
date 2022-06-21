import 'package:bloc/bloc.dart';
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
      //REAL LOGIN
      //resp = await _userService.login(username: event.username, password: event.password);

      resp = await _userService.login(username: "essiggurke", password: "password");


      emit(LogInSuccess(userID: resp.userId.toInt(), token: resp.token));

      print("Login Success !");
    } on GrpcError catch (err) {
      print("Login Failed GRPC ERROR!:$err");
      print("Login Failed GRPC ERROR!:${err.runtimeType}");

      emit(LogInFail(message: "ERROR: ${err.message}"));
    } catch (err) {
      print("Login Failed ERROR!:$err");
      print("Login Failed ERROR!:${err.runtimeType}");

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
