import 'package:frontend/api/model/resource.dart';

abstract class ResourceService {
  Future<Resource> getResource(int id);
}