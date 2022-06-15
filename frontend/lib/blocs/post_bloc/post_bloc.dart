import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/grpc/grpc_post_service.dart';
import 'package:frontend/api/model/post.dart';
import 'package:frontend/api/post_service.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostService _postService = GRPCPostService("10.0.2.2", port: 8080);

  PostBloc() : super(PostInitial()) {
    on<CreatePost>(_onCreatePost);
    on<LoadPosts>(_onLoadPosts);
  }

  void _onCreatePost(CreatePost event, Emitter<PostState> emit) async {
    emit(PostSaving());
    await _postService.createPost(ownerId: event.ownerId, post: event.post);

    emit(PostSaved());
  }

  void _onLoadPosts(LoadPosts event, Emitter<PostState> emit) async {
    emit(PostsLoading());

    emit(PostsLoaded(postList: await _postService.getPosts(event.userId)));
  }
}
