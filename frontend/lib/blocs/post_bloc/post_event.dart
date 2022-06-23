part of 'post_bloc.dart';

@immutable
abstract class PostEvent {}

class CreatePost extends PostEvent {
  final String description;
  final Uint8List? resourceData;
  final String? resourceMimeType;

  CreatePost({
    required this.description,
    this.resourceData,
    this.resourceMimeType,
  });
}

class LoadPosts extends PostEvent {
  final int userId;

  LoadPosts({
    required this.userId,
  });
}
