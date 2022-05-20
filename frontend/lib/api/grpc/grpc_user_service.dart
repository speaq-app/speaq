import 'package:fixnum/fixnum.dart';
import 'package:frontend/api/grpc/protos/user.pbgrpc.dart';
import 'package:frontend/api/user_service.dart';
import 'package:frontend/api/model/profile.dart';
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
    GetUserProfileResponse resp = await _client.getUserProfile(GetUserProfileRequest()..userId = Int64(id));
    return Profile(
      name: resp.name,
      username: resp.username,
      description: resp.description,
      website: resp.website,
      profileImageBlurHash: resp.profileImageBlurHash,
      profileImageResourceId: resp.profileImageResourceId.toInt(),
    );
  }

  @override
  Future<void> updateProfile({
    required int id,
    required Profile profile,
  }) async {
    await _client.updateUserProfile(
      UpdateUserProfileRequest()
        ..userId = Int64(id)
        ..name = profile.name
        ..username = profile.username
        ..description = profile.description
        ..website = profile.website,
    );
  }

  @override
  Future<LoginResponse> login({required String username, required String password}) async {
    // TODO: implement login
    LoginResponse resp = await _client.login(
      LoginRequest()
        ..username = username
        ..password = password
    );

    return resp;
  }
}
