import 'package:hive/hive.dart';

part 'resource.g.dart';

@HiveType(typeId: 2)
class Resource extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String data;

  @HiveField(2)
  final String mimeType;

  @HiveField(3)
  final Duration? audioDuration;

  Resource({
    required this.id,
    required this.data,
    required this.mimeType,
    required this.audioDuration,
  });
}
