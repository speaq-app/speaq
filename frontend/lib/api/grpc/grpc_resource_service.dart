import 'package:fixnum/fixnum.dart';
import 'package:frontend/api/grpc/protos/resource.pbgrpc.dart';
import 'package:frontend/api/model/resource.dart';
import 'package:frontend/api/resource_service.dart';
import 'package:grpc/grpc.dart';

abstract class GRPCResourceService implements ResourceService {
  static final ResourceClient _client = ResourceClient(
    ClientChannel(
      "10.0.2.2",
      port: 8080,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    ),
  );

  @override
  Future<Resource> getResource(int id) async {
    GetResourceResponse resp = await _client.getResource(
      GetResourceRequest()..id = Int64(id),
    );

    return Resource(
      id: id,
      data: resp.data,
      name: resp.name,
      mimeType: resp.mimeType,
      size: resp.size.toInt(),
    );
  }
}
