import 'package:bloc/bloc.dart';
import 'package:frontend/api/auth_service.dart';
import 'package:frontend/api/grpc/grpc_auth_service.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:grpc/grpc.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthService _authService = GRPCAuthService("10.0.2.2", port: 8080);

  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterUser>(_onRegisterUser);
  }

  void _onRegisterUser(RegisterUser event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    try {
      if (event.username.isEmpty || event.username.length > maxUsernameLength) throw GrpcError.invalidArgument();
      if (event.password.isEmpty || event.password.length > maxPasswordLength) throw GrpcError.invalidArgument();
      if (event.passwordCheck.isEmpty || event.passwordCheck != event.password) throw GrpcError.invalidArgument();

      await _authService.registerUser(event.username, event.password);
    } on GrpcError catch (e) {
      emit(RegisterError(e.code));
      return;
    }
    emit(RegisterSuccess());
  }
}
