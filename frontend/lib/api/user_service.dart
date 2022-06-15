import 'package:frontend/api/grpc/protos/user.pbgrpc.dart';
import 'package:frontend/api/model/profile.dart';
import 'package:frontend/api/model/user.dart';

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
  Future<List<FollowUser>> getFollower({
    required List<int> ids,
  });
  Future<List<FollowUser>> getFollowing({
    required List<int> ids,
  });
}
