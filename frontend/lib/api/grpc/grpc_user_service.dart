import 'package:fixnum/fixnum.dart';
import 'package:frontend/api/protos/user.pbgrpc.dart';
import 'package:frontend/api/user_service.dart';
import 'package:frontend/pages/profile/model/profile.dart';
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
  Future<Profile> getProfile(int id) async {
    GetUserProfileResponse resp = await _client
        .getUserProfile(GetUserProfileRequest()..userId = Int64(id));
    return Profile(
      name: resp.name,
      username: resp.username,
      description: resp.description,
      website: resp.website,
    );
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
      ..userId = Int64(id)
      ..name = name
      ..username = username
      ..description = description
      ..website = website);
  }
}
