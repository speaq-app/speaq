part of 'post_bloc.dart';

@immutable
abstract class PostEvent {}

class SavePost extends PostEvent {
  final int userId;
  final Post post;

  SavePost({
    required this.userId,
    required this.post,
  });
}