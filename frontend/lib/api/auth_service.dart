import 'package:frontend/api/grpc/protos/auth.pbgrpc.dart';


abstract class AuthService {
  Future<void> registerUser(String username, String password);

  Future<LoginResponse> loginUser({required String username, required String password});

}
