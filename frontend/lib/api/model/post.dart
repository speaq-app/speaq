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

  @HiveField(4)
  final int ownerID;

  @HiveField(5)
  final int numberOfLikes;

  @HiveField(6)
  final int numberOfComments;

  @HiveField(7)
  final String ownerName;

  @HiveField(8)
  final String ownerUsername;

  Post({
    required this.id,
    required this.resourceID,
    required this.date,
    required this.description,
    required this.ownerID,
    this.numberOfLikes = 0,
    this.numberOfComments = 0,
    this.ownerName = "",
    this.ownerUsername = "",
  });
}
