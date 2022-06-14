import 'package:frontend/api/model/profile.dart';

abstract class UserService {
  Future<Profile> getProfile(int id);

  Future<void> updateProfile({
    required int id,
    required Profile profile,
  });

  Future<List<int>> getFollowerIDs({
    required int id,
  });
  Future<List<int>> getFollowingIDs({
    required int id,
  });
}
