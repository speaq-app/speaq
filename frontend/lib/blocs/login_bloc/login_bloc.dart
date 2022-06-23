import 'package:bloc/bloc.dart';
import 'package:frontend/api/auth_service.dart';
import 'package:frontend/api/grpc/grpc_auth_service.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService _authService = GRPCAuthService();

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
      //TODO: Save token
      emit(LoginSuccess(token: token));
    } on GrpcError catch (err) {
      print(err.message);
      emit(LoginError());
    }
  }
}
