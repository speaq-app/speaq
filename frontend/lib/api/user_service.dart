import 'package:fixnum/fixnum.dart';
import 'package:frontend/api/protos/User.pbgrpc.dart';
import 'package:grpc/grpc.dart';

abstract class UserService {
  static final UserClient _client = UserClient(
    ClientChannel(
      "10.0.2.2",
      port: 8080,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    ),
  );

  static Future<dynamic> updateProfile(int id, UpdateUserProfileRequest profile) async {
    return _client.updateUserProfile(
      UpdateUserProfileRequest()
      ..id = Int64(id)
      ..name = profile.name
      ..username = profile.username
      ..description = profile.description
      ..website = profile.website
    );
  }
}
