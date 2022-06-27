import 'package:bloc/bloc.dart';
import 'package:frontend/api/auth_service.dart';
import 'package:frontend/api/grpc/grpc_auth_service.dart';
import 'package:frontend/utils/backend_utils.dart';
import 'package:grpc/grpc.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthService _authService = GRPCAuthService(
    BackendUtils.getHost(),
    port: BackendUtils.getPort(),
  );

  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterUser>(_onRegisterUser);
  }

  void _onRegisterUser(RegisterUser event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    try {
      await _authService.registerUser(event.username, event.password);
    } on GrpcError catch (e) {
      emit(RegisterError(e.code));
      return;
    }
    emit(RegisterSuccess());
  }
}
