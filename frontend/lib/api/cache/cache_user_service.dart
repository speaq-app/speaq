import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:frontend/api/user_service.dart';
import 'package:frontend/api/model/profile.dart';

class CacheUserService implements UserService {
  final UserService _userService;
  final Box box = Hive.box<Profile>("profile");

  CacheUserService(this._userService);

  @override
  Future<Profile> getProfile(int id) async {
    Profile? _profile = box.get(id);
    if (_profile == null) {
      _profile = await _userService.getProfile(id);
      box.put(id, _profile);
    }

    return _profile;
  }

  @override
  Future<void> updateProfile({
    required int id,
    required Profile profile,
  }) {
    box.put(id, profile);
    return _userService.updateProfile(
      id: id,
      profile: profile,
    );
  }
}
