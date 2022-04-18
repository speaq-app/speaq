import 'package:frontend/pages/profile/model/profile.dart';

abstract class UserService {
  Future<Profile> getProfile(int id);

  Future<dynamic> updateProfile({
    required int id,
    required String name,
    required String username,
    required String description,
    required String website,
  }) async {}
}
