import 'package:hive/hive.dart';
part 'post.g.dart';

@HiveType(typeId: 3)
class Post extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int resourceID;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String description;

  Post({
    required this.id,
    required this.resourceID,
    required this.date,
    required this.description,
  });
}