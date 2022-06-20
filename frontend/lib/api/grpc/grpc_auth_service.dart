import 'package:frontend/api/auth_service.dart';
import 'package:frontend/api/grpc/protos/auth.pbgrpc.dart';
import 'package:grpc/grpc.dart';

class GRPCAuthService implements AuthService {
  final AuthClient _client = AuthClient(
    ClientChannel(
      "10.0.2.2",
      port: 8080,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    ),
  );

  @override
  Future<void> registerUser(String username, String password) async {
    await _client.register(RegisterRequest(
      username: username,
      password: password,
    ));
  }
}
