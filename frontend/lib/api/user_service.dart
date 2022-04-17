abstract class UserService {
  Future<dynamic> getProfile(int id) async {}

  Future<dynamic> updateProfile({
    required int id,
    required String name,
    required String username,
    required String description,
    required String website,
  }) async {}
}
