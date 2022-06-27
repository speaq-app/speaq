import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    on<SaveResource>(_onSaveResource);
  }

  void _onLoadResource(LoadResource event, Emitter<ResourceState> emit) async {
    emit(ResourceLoading());
    var resource = await _resourceService.getResource(event.resourceId);
    var decodedData = base64Decode(resource.data);

    emit(ResourceLoaded(resource, decodedData));
  }

  void _onSaveResource(SaveResource event, Emitter<ResourceState> emit) async {
    emit(ResourceSaving());
    //TODO "Resource Uploaden"
    //var resourceID = await _resourceService.uploadResource();
    emit(ResourceSaved());
  }
}
