import 'package:bloc/bloc.dart';
import 'package:frontend/api/auth_service.dart';
import 'package:frontend/api/grpc/grpc_auth_service.dart';
import 'package:frontend/api/grpc/protos/auth.pb.dart';
import 'package:frontend/utils/token_utils.dart';
import 'package:grpc/grpc.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService _authService = GRPCAuthService("10.0.2.2", port: 8080);

  LoginBloc() : super(LoginInitial()) {
    on<Login>(_onLogin);
  }

  void _onLogin(Login event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      LoginResponse resp = await _authService.loginUser(
        username: event.username,
        password: event.password,
      );
      await TokenUtils.setToken(resp.token);
      emit(LoginSuccess(token: resp.token, userID: resp.userId.toInt()));
    } on GrpcError catch (e) {
      print(e.codeName);
      emit(LoginError(e.code));
    }
  }
}
