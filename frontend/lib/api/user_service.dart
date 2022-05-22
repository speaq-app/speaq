import 'package:frontend/api/grpc/protos/user.pb.dart';
import 'package:frontend/api/model/profile.dart';

abstract class UserService {
  Future<Profile> getProfile(int id);

  Future<void> updateProfile({
    required int id,
    required Profile profile,
  });

  Future<String> login({required String username, required String password});
}
