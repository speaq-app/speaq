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
  Future<List<int>> getFollowerIDs({required int id}) async {
    GetUserFollowerIDsResponse resp = await _client
        .getUserFollowerIDs(GetUserProfileRequest()..userId = Int64(id));
    List<int> follower = [];
    for (Int64 i in resp.followerIds) {
      follower.add(i.toInt());
    }
    return follower;
  }

  @override
  Future<List<int>> getFollowingIDs({required int id}) async {
    GetUserFollowingIDsResponse resp = await _client
        .getUserFollowingIDs(GetUserProfileRequest()..userId = Int64(id));
    List<int> following = [];
    for (Int64 i in resp.followingIds) {
      following.add(i.toInt());
    }
    return following;
  }


  @override
  Future<List<FollowUser>> getFollower({required List<int> ids}) async {
    List<Int64> int64IDs = [];
    for (int i in ids) {
      int64IDs.add(Int64(i));
    }

    GetUserFollowerResponse resp = await _client.getUserFollower(GetUserFollowerRequest(followerIds: int64IDs));

    return resp.follower;
  }
  @override
  Future<List<FollowUser>> getFollowing({required List<int> ids}) async {
    List<Int64> int64IDs = [];
    for (int i in ids) {
      int64IDs.add(Int64(i));
    }

    GetUserFollowingResponse resp = await _client.getUserFollowing(GetUserFollowingRequest(followingIds: int64IDs));

    return resp.following;
  }


  @override
  Future<LoginResponse> login({required String username, required String password}) async {

    print("username Login: " + username);
    print("password Login: " + password);

    LoginResponse resp = await _client.login(
      LoginRequest()
        ..username = username
        ..password = password
    );

    print("username Response: ${resp.userId}");
    print("password Response: " + resp.token);

    return resp;
  }
}
