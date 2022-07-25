import 'package:hive/hive.dart';

part 'chat.g.dart';

@HiveType(typeId: 4)
class Chat extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final List<int> participantIDs;

  @HiveField(3)
  final List<int> messageIDs;

  Chat({
    required this.id,
    required this.title,
    required this.participantIDs,
    required this.messageIDs,
  });
}
