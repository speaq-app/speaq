import 'package:frontend/api/grpc/protos/auth.pb.dart';

abstract class AuthService {
  Future<void> registerUser(String username, String password);

  Future<String> login({
    required String username,
    required String password,
  });
}
