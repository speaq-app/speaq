import 'dart:developer';

import 'package:frontend/api/model/resource.dart';
import 'package:frontend/api/resource_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CacheResourceService implements ResourceService {
  final ResourceService _resourceService;
  final Box box = Hive.box<Resource>("resource");

  CacheResourceService(this._resourceService);

  @override
  Future<Resource> getResource(int id) async {
    Resource? _resource = box.get(id);
    if (_resource == null) {
      log("loading new Res");
      _resource = await _resourceService.getResource(id);
      box.put(id, _resource);
    }
    log("returning res");
    return _resource;
  }
}
