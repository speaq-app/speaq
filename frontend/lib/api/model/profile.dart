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

  Profile({
    required this.name,
    required this.username,
    required this.description,
    required this.website,
  });
}
