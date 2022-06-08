import 'package:hive/hive.dart';
part 'post.g.dart';

@HiveType(typeId: 3)
class Post extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int userID;

  @HiveField(2)
  final String description;

  @HiveField(4)
  final int resourceID;

  @HiveField(5)
  final DateTime date;


  Post( {
    required this.id,
    required this.userID,
    required this.description,
    required this.resourceID,
    required this.date,
  });
}
