import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/grpc/grpc_post_service.dart';
import 'package:frontend/api/model/post.dart';
import 'package:frontend/api/post_service.dart';
import 'package:meta/meta.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostService _postService = GRPCPostService("10.0.2.2", port: 8080);

  PostBloc() : super(PostInitial()) {
    on<SavePost>(_onSavePost);
    on<LoadPosts>(_onLoadPosts);
  }

  void _onSavePost(SavePost event, Emitter<PostState> emit) async {
    emit(PostSaving());
    await Future.delayed(const Duration(seconds: 5)); //removable
    await _postService.createPost(post: event.post, id: event.userId);
    emit(PostSaved());
  }

  void _onLoadPosts(LoadPosts event, Emitter<PostState> emit) async {
    //User ID nehmen
    //Alle Nutzer holen denen man folgt
    //Alle Beiträge der Nutzer holen
    //Beiträge chronologisch anzeigen

    emit(PostsLoading());
    await Future.delayed(const Duration(seconds: 1)); //removable
    emit(PostsLoaded());
  }
}
