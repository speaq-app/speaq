import 'package:frontend/pages/profile/model/profile.dart';

abstract class UserService {
  Future<Profile> getProfile(int id);

  Future<void> updateProfile({
    required int id,
    required Profile userProfile,
  });
}
