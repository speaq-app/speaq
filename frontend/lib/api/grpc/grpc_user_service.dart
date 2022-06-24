import 'package:fixnum/fixnum.dart';
import 'package:frontend/api/grpc/protos/user.pbgrpc.dart';
import 'package:frontend/api/model/profile.dart';
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
  Future<List<int>> getFollowerIDs({required int id}) async {
    GetUserFollowerIDsResponse resp = await _client.getUserFollowerIDs(GetUserProfileRequest(userId: Int64(id)));
    List<int> follower = [];
    for (Int64 i in resp.followerIds) {
      follower.add(i.toInt());
    }
    return follower;
  }

  @override
  Future<List<int>> getFollowingIDs({required int id}) async {
    GetUserFollowingIDsResponse resp = await _client.getUserFollowingIDs(GetUserProfileRequest()..userId = Int64(id));
    List<int> following = [];
    for (Int64 i in resp.followingIds) {
      following.add(i.toInt());
    }
    return following;
  }

  @override
  Future<List<CondensedUser>> getFollower({required List<int> ids}) async {
    List<Int64> int64IDs = [];
    for (int i in ids) {
      int64IDs.add(Int64(i));
    }

    CondensedUserListResponse resp = await _client.getUserFollower(GetUserFollowerRequest(followerIds: int64IDs));

    return resp.users;
  }

  @override
  Future<List<CondensedUser>> getFollowing({required List<int> ids}) async {
    List<Int64> int64IDs = [];
    for (int i in ids) {
      int64IDs.add(Int64(i));
    }

    CondensedUserListResponse resp = await _client.getUserFollowing(GetUserFollowingRequest(followingIds: int64IDs));

    return resp.users;
  }

  @override
  Future<bool> checkIfFollowing({required int userID, required int followerID}) async {
    IsFollowingResponse resp = await _client.checkIfFollowing(CheckIfFollowingRequest(userId: Int64(userID), followerId: Int64(followerID)));

    return resp.isFollowing;
  }

  @override
  Future<bool> followUnfollow({required int userID, required int followerID}) async {
    IsFollowingResponse resp = await _client.followUnfollow(FollowUnfollowRequest(userId: Int64(userID), followerId: Int64(followerID)));

    return resp.isFollowing;
  }

  @override
  Future<List<CondensedUser>> userByUsername({required String searchTerm}) async {
    CondensedUserListResponse resp = await _client.usersByUsername(SearchUserRequest(term: searchTerm));

    return resp.users;
  }
}
