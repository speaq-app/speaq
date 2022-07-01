part of 'post_bloc.dart';

@immutable
abstract class PostEvent {}

class ProcessingPost extends PostEvent {
  final String message;

  ProcessingPost(this.message);
}

class CreatePost extends PostEvent {
  final String description;
  final Uint8List? resourceData;
  final String? resourceMimeType;
  final Duration? audioDuration;

  CreatePost({
    required this.description,
    this.resourceData,
    this.resourceMimeType,
    this.audioDuration,
  });
}

class LoadPosts extends PostEvent {
  final int userId;

  LoadPosts({
    this.userId = 0,
  });
}
