import 'package:fixnum/fixnum.dart';
import 'package:frontend/api/grpc/protos/User.pbgrpc.dart';
import 'package:frontend/api/user_service.dart';
import 'package:grpc/grpc.dart';

class GRPCUserService implements UserService {
  final UserClient _client = UserClient(
    ClientChannel(
      "10.0.2.2",
      port: 8080,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    ),
  );

  @override
  Future<dynamic> getProfile(int id) async {
    return _client.getUser(GetUserRequest()..id = Int64(id));
  }

  @override
  Future<dynamic> updateProfile({
    required int id,
    required String name,
    required String username,
    required String description,
    required String website,
  }) async {
    return _client.updateUserProfile(UpdateUserProfileRequest()
      ..id = Int64(id)
      ..name = name
      ..username = username
      ..description = description
      ..website = website);
  }
}
