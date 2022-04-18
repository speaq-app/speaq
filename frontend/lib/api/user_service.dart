import 'package:frontend/pages/profile/model/profile.dart';

abstract class UserService {
  Future<Profile> getProfile(int id);

  Future<dynamic> updateProfile({
    required int id,
    required Profile userProfile,
  }) async {}
}
