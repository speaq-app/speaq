import 'package:fixnum/fixnum.dart';
import 'package:frontend/api/grpc/protos/user.pbgrpc.dart';
import 'package:frontend/api/model/user.dart';
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
    GetUserProfileResponse resp = await _client
        .getUserProfile(GetUserProfileRequest()..userId = Int64(id));
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
  Future<List<int>> getFollower({required int id}) async {
    GetUserFollowerResponse resp = await _client
        .getUserFollower(GetUserFollowerRequest()..userId = Int64(id));
    List<int> follower = [];
    for (Int64 i in resp.followerIds) {
      follower.add(i.toInt());
    }
    return follower;
  }
}
