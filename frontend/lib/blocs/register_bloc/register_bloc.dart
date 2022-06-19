import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:frontend/api/auth_service.dart';
import 'package:frontend/api/grpc/grpc_auth_service.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthService _authService = GRPCAuthService();

  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterUser>(_onRegisterUser);
  }

  void _onRegisterUser(RegisterUser event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    await Future.delayed(const Duration(seconds: 1));
    try {
      await _authService.registerUser(event.username, event.password);
    } on Exception {
      emit(RegisterError());
      return;
    }
    emit(RegisterSuccess());
  }
}
