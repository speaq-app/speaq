import 'package:bloc/bloc.dart';
import 'package:frontend/api/grpc/grpc_resource_service.dart';
import 'package:frontend/api/model/resource.dart';
import 'package:frontend/api/resource_service.dart';
import 'package:meta/meta.dart';

part 'resource_event.dart';
part 'resource_state.dart';

class ResourceBloc extends Bloc<ResourceEvent, ResourceState> {
  final ResourceService _resourceService =
      GRPCResourceService("10.0.2.2", port: 8080);

  ResourceBloc() : super(ResourceInitial()) {
    on<LoadResource>(_onLoadResource);
    on<SaveResource>(_onSaveResource);
  }

  void _onLoadResource(LoadResource event, Emitter<ResourceState> emit) async {
    emit(ResourceLoading());
    await Future.delayed(const Duration(seconds: 2)); //removeable

    var resource = await _resourceService.getResource(event.resourceId);
    emit(ResourceLoaded(resource));
  }

  void _onSaveResource(SaveResource event, Emitter<ResourceState> emit) async {
    emit(ResourceSaving());
    emit(ResourceSaved());
  }
}
