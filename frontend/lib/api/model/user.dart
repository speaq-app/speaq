import 'package:frontend/api/model/profile.dart';
import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final Profile profile;

  @HiveField(2)
  final Profile password;

  User( {
    required this.id,
    required this.profile,
    required this.password,
  });
}
