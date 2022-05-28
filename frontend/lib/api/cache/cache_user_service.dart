import 'package:frontend/api/grpc/protos/user.pb.dart';
import 'package:frontend/api/model/user.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:frontend/api/user_service.dart';
import 'package:frontend/api/model/profile.dart';

class CacheUserService implements UserService {
  final UserService _userService;
  final Box _profileBox = Hive.box<Profile>("profile");
  final Box _userBox = Hive.box<User>("user");

  CacheUserService(this._userService);

  @override
  Future<Profile> getProfile(int id) async {
    Profile? _profile = _profileBox.get(id);
    if (_profile == null) {
      _profile = await _userService.getProfile(id);
      _profileBox.put(id, _profile);
    }

    return _profile;
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
  Future<LoginResponse> login({required String username, required String password}) {
    // TODO: implement login
    throw UnimplementedError();
  }
}
