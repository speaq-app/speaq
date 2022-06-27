import 'package:hive/hive.dart';

part 'profile.g.dart';

@HiveType(typeId: 1)
class Profile extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String website;

  @HiveField(4)
  final String profileImageBlurHash;

  @HiveField(5)
  final int profileImageResourceId;

  @HiveField(6)
  final bool isOwnProfile;

  Profile({
    required this.name,
    required this.username,
    required this.description,
    required this.website,
    this.profileImageBlurHash = "",
    this.profileImageResourceId = 0,
    this.isOwnProfile = false,
  });
}
