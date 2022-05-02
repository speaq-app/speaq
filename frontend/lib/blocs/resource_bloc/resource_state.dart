part of 'resource_bloc.dart';

@immutable
abstract class ResourceState {}

class ResourceInitial extends ResourceState {}

class ResourceLoading extends ResourceState {}

class ResourceLoaded extends ResourceState {
  final Resource resource;

  ResourceLoaded(this.resource);
}

class ResourceSaving extends ResourceState {}

class ResourceSaved extends ResourceState {}
