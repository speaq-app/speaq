part of 'post_bloc.dart';

@immutable
abstract class PostState {}

class PostInitial extends PostState {}

class PostSaving extends PostState {}

class PostSaved extends PostState {}

class PostsLoading extends PostState {}

class PostsLoaded extends PostState {
  final List<Post> postList;

  PostsLoaded({required this.postList});
}
