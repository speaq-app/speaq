part of 'post_bloc.dart';

@immutable
abstract class PostState {}

class PostInitial extends PostState {}

class PostSaving extends PostState {}

class PostSaved extends PostState {}
