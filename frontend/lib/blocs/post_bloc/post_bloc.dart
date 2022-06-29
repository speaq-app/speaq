import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/grpc/grpc_post_service.dart';
import 'package:frontend/api/model/post.dart';
import 'package:frontend/api/post_service.dart';
import 'package:frontend/utils/backend_utils.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostService _postService = GRPCPostService(
    BackendUtils.getHost(),
    port: BackendUtils.getPort(),
  );

  PostBloc() : super(PostInitial()) {
    on<CreatePost>(_onCreatePost);
    on<LoadPosts>(_onLoadPosts);
  }

  void _onCreatePost(CreatePost event, Emitter<PostState> emit) async {
    emit(PostSaving());

    await _postService.createPost(
      description: event.description,
      resourceData: event.resourceData,
      resourceMimeType: event.resourceMimeType,
      audioDuration: event.audioDuration,
    );

    emit(PostSaved());
  }

  void _onLoadPosts(LoadPosts event, Emitter<PostState> emit) async {
    emit(PostsLoading());

    emit(PostsLoaded(postList: await _postService.getPosts(event.userId)));
  }
}
