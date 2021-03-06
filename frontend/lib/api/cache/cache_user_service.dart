import 'package:frontend/api/grpc/protos/user.pbgrpc.dart';
import 'package:frontend/api/grpc/protos/user.pb.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:frontend/api/user_service.dart';
import 'package:frontend/api/model/profile.dart';

class CacheUserService implements UserService {
  final UserService _userService;
  final Box _profileBox = Hive.box<Profile>("profile");

  CacheUserService(this._userService);

  @override
  Future<Profile> getProfile(int id) async {
    Profile? profile = _profileBox.get(id);
    if (profile == null) {
      profile = await _userService.getProfile(id);
      _profileBox.put(id, profile);
    }

    return profile;
  }

  @override
  Future<void> updateProfile({
    required int id,
    required Profile profile,
  }) {
    //Checks?
    Profile cachedProfile = _profileBox.get(id);

    Profile newCachedProfile = Profile(
      name: profile.name,
      username: profile.username,
      description: profile.description,
      website: profile.website,
      profileImageBlurHash: cachedProfile.profileImageBlurHash,
      profileImageResourceId: cachedProfile.profileImageResourceId,
    );

    _profileBox.put(id, newCachedProfile);
    return _userService.updateProfile(
      id: id,
      profile: newCachedProfile,
    );
  }

  Future<void> clearProfile(int id) {
    return _profileBox.delete(id);
  }

  @override
  Future<List<int>> getFollowerIDs({required int id}) {
    // TODO: implement getFollower-cache
    throw UnimplementedError();
  }

  @override
  Future<List<int>> getFollowingIDs({required int id}) {
    // TODO: implement getFollower-cache
    throw UnimplementedError();
  }

  @override
  Future<List<CondensedUser>> getFollower({required List<int> ids}) {
    // TODO: implement getFollower-cache
    throw UnimplementedError();
  }

  @override
  Future<List<CondensedUser>> getFollowing({required List<int> ids}) {
    // TODO: implement getFollower-cache
    throw UnimplementedError();
  }

  @override
  Future<bool> checkIfFollowing(
      {required int userID, required int followerID}) async {
    // TODO: implement checkIfFollowing-cache
    throw UnimplementedError();
  }

  @override
  Future<bool> followUnfollow(
      {required int userID, required int followerID}) async {
    // TODO: implement followUnfollow-cache
    throw UnimplementedError();
  }

  @override
  Future<List<CondensedUser>> searchUser({required String searchTerm}) {
    // TODO: implement userByUsername
    throw UnimplementedError();
  }

}
