part of 'post_bloc.dart';

@immutable
abstract class PostEvent {}

class CreatePost extends PostEvent {
  final int userId;
  final Post post;

  CreatePost({
    required this.userId,
    required this.post,
  });
}

class LoadPosts extends PostEvent {
  final int userId;

  LoadPosts({
    required this.userId,
  });
}
