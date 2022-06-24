import 'package:frontend/api/grpc/protos/user.pb.dart';
import 'package:frontend/api/grpc/protos/user.pbgrpc.dart';
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

  Future<List<FollowUser>> getFollower({
    required List<int> ids,
  });

  Future<List<FollowUser>> getFollowing({
    required List<int> ids,
  });

  Future<bool> checkIfFollowing({required int userID, required int followerID});

  Future<bool> followUnfollow({required int userID, required int followerID});
}
