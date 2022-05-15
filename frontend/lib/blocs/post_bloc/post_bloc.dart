import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/cache/cache_user_service.dart';
import 'package:frontend/api/grpc/grpc_user_service.dart';
import 'package:frontend/api/model/post.dart';
import 'package:frontend/api/user_service.dart';
import 'package:meta/meta.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final UserService _userService = CacheUserService(GRPCUserService());

  PostBloc() : super(PostInitial()) {
    on<SavePost>(_onSavePost);
  }

  void _onSavePost(SavePost event, Emitter<PostState> emit) async {
    emit(PostSaving());
    await Future.delayed(const Duration(seconds: 2)); //removable
    emit(PostSaved());
  }
}