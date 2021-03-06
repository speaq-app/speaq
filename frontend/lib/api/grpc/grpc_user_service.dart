import 'package:fixnum/fixnum.dart';
import 'package:frontend/api/grpc/protos/user.pbgrpc.dart';
import 'package:frontend/api/model/profile.dart';
import 'package:frontend/api/user_service.dart';
import 'package:frontend/utils/token_utils.dart';
import 'package:grpc/grpc_connection_interface.dart';

class GRPCUserService implements UserService {
  late UserClient _client;
  late CallOptions _callOptions;

  GRPCUserService(ClientChannelBase channel) {
    _client = UserClient(channel);
    var token = TokenUtils.getToken();
    _callOptions = CallOptions(metadata: {"authorization": "bearer $token"});
  }

  @override
  Future<Profile> getProfile(int id) async {
    GetUserProfileResponse resp = await _client.getUserProfile(
      GetUserProfileRequest()..userId = Int64(id),
      options: _callOptions,
    );
    return Profile(
      name: resp.name,
      username: resp.username,
      description: resp.description,
      website: resp.website,
      profileImageBlurHash: resp.profileImageBlurHash,
      profileImageResourceId: resp.profileImageResourceId.toInt(),
      isOwnProfile: resp.isOwnProfile,
    );
  }

  @override
  Future<void> updateProfile({
    required int id,
    required Profile profile,
  }) async {
    await _client.updateUserProfile(
      UpdateUserProfileRequest()
        ..name = profile.name
        ..username = profile.username
        ..description = profile.description
        ..website = profile.website,
      options: _callOptions,
    );
  }

  @override
  Future<List<int>> getFollowerIDs({required int id}) async {
    GetUserFollowerIDsResponse resp = await _client.getUserFollowerIDs(
      GetUserProfileRequest(userId: Int64(id)),
      options: _callOptions,
    );
    List<int> follower = [];
    for (Int64 i in resp.followerIds) {
      follower.add(i.toInt());
    }
    return follower;
  }

  @override
  Future<List<int>> getFollowingIDs({required int id}) async {
    GetUserFollowingIDsResponse resp = await _client.getUserFollowingIDs(
      GetUserProfileRequest()..userId = Int64(id),
      options: _callOptions,
    );
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

    CondensedUserListResponse resp = await _client.getUserFollower(
      GetUserFollowerRequest(followerIds: int64IDs),
      options: _callOptions,
    );

    return resp.users;
  }

  @override
  Future<List<CondensedUser>> getFollowing({required List<int> ids}) async {
    List<Int64> int64IDs = [];
    for (int i in ids) {
      int64IDs.add(Int64(i));
    }

    CondensedUserListResponse resp = await _client.getUserFollowing(
      GetUserFollowingRequest(followingIds: int64IDs),
      options: _callOptions,
    );

    return resp.users;
  }

  @override
  Future<bool> checkIfFollowing({required int userID, required int followerID}) async {
    IsFollowingResponse resp = await _client.checkIfFollowing(
      CheckIfFollowingRequest(userId: Int64(userID), followerId: Int64(followerID)),
      options: _callOptions,
    );

    return resp.isFollowing;
  }

  @override
  Future<bool> followUnfollow({required int userID, required int followerID}) async {
    IsFollowingResponse resp = await _client.followUnfollow(
      FollowUnfollowRequest(userId: Int64(userID), followerId: Int64(followerID)),
      options: _callOptions,
    );

    return resp.isFollowing;
  }

  @override
  Future<List<CondensedUser>> searchUser({required String searchTerm}) async {
    CondensedUserListResponse resp = await _client.searchUser(
      SearchUserRequest(term: searchTerm),
      options: _callOptions,
    );

    return resp.users;
  }
}
