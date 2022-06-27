import 'package:flutter/foundation.dart';
import 'package:frontend/api/auth_service.dart';
import 'package:frontend/api/grpc/protos/auth.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:grpc/grpc.dart';

class GRPCAuthService implements AuthService {
  late AuthClient _client;

  GRPCAuthService(
    String ip, {
    int port = 443,
  }) {
    _client = AuthClient(
      ClientChannel(
        ip,
        port: port,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure()),
      ),
    );
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
