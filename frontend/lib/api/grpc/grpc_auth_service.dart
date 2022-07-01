import 'package:frontend/api/auth_service.dart';
import 'package:frontend/api/grpc/protos/auth.pbgrpc.dart';
import 'package:grpc/grpc_connection_interface.dart';

class GRPCAuthService implements AuthService {
  late AuthClient _client;

  GRPCAuthService(ClientChannelBase channel) {
    _client = AuthClient(channel);
  }

  @override
  Future<void> registerUser(String username, String password) async {
    await _client.register(RegisterRequest(
      username: username,
      password: password,
    ));
  }

  @override
  Future<String> login({
    required String username,
    required String password,
  }) async {
    LoginResponse resp = await _client.login(
      LoginRequest()
        ..username = username
        ..password = password,
    );
    return resp.token;
  }
}
