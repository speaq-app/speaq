import 'package:frontend/api/grpc/protos/user.pb.dart';
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
  Future<LoginResponse> login({required String username, required String password}) {
    // TODO: implement login
    throw UnimplementedError();
  }
}
