part of 'resource_bloc.dart';

@immutable
abstract class ResourceEvent {}

class LoadResource extends ResourceEvent {
  final int resourceId;

  LoadResource({required this.resourceId});
}

class SaveResource extends ResourceEvent {}
