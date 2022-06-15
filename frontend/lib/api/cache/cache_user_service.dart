import 'package:frontend/api/grpc/protos/user.pbgrpc.dart';
import 'package:frontend/api/model/user.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:frontend/api/user_service.dart';
import 'package:frontend/api/model/profile.dart';

class CacheUserService implements UserService {
  final UserService _userService;
  final Box _box = Hive.box<Profile>("profile");

  CacheUserService(this._userService);

  @override
  Future<Profile> getProfile(int id) async {
    Profile? _profile = _box.get(id);
    if (_profile == null) {
      _profile = await _userService.getProfile(id);
      _box.put(id, _profile);
    }

    return _profile;
  }

  @override
  Future<void> updateProfile({
    required int id,
    required Profile profile,
  }) {
    //Checks?
    Profile cachedProfile = _box.get(id);

    Profile newCachedProfile = Profile(
      name: profile.name,
      username: profile.username,
      description: profile.description,
      website: profile.website,
      profileImageBlurHash: cachedProfile.profileImageBlurHash,
      profileImageResourceId: cachedProfile.profileImageResourceId,
    );

    _box.put(id, newCachedProfile);
    return _userService.updateProfile(
      id: id,
      profile: newCachedProfile,
    );
  }

  Future<void> clearProfile(int id) {
    return _box.delete(id);
  }

  @override
  Future<List<int>> getFollowerIDs({required int id}) {
    // TODO: implement getFollower
    throw UnimplementedError();
  }
  @override
  Future<List<int>> getFollowingIDs({required int id}) {
    // TODO: implement getFollower
    throw UnimplementedError();
  }
  @override
  Future<List<FollowUser>> getFollower({required List<int> ids}) {
    // TODO: implement getFollower
    throw UnimplementedError();
  }
  @override
  Future<List<FollowUser>> getFollowing({required List<int> ids}) {
    // TODO: implement getFollower
    throw UnimplementedError();
  }
}
