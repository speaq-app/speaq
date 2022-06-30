import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/api/cache/cache_resource_service.dart';
import 'package:frontend/api/grpc/grpc_resource_service.dart';
import 'package:frontend/api/model/resource.dart';
import 'package:frontend/api/resource_service.dart';
import 'package:frontend/utils/backend_utils.dart';

part 'resource_event.dart';
part 'resource_state.dart';

class ResourceBloc extends Bloc<ResourceEvent, ResourceState> {
  final ResourceService _resourceService = GRPCResourceService(
    BackendUtils.getHost(),
    port: BackendUtils.getPort(),
  );

  ResourceBloc() : super(ResourceInitial()) {
    on<LoadResource>(_onLoadResource);
  }

  void _onLoadResource(LoadResource event, Emitter<ResourceState> emit) async {
    emit(ResourceLoading());
    var resource = await _resourceService.getResource(event.resourceId);

    emit(ResourceLoaded(resource, Uint8List.fromList(resource.data)));
  }
}
