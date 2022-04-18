import 'package:fixnum/fixnum.dart';
import 'package:frontend/api/grpc/protos/resource.pbgrpc.dart';
import 'package:frontend/api/model/resource.dart';
import 'package:frontend/api/resource_service.dart';
import 'package:grpc/grpc.dart';

class GRPCResourceService implements ResourceService {
  late ResourceClient _client;

  GRPCResourceService(
    String ip, {
    int port = 443,
  }) {
    _client = ResourceClient(
      ClientChannel(
        ip,
        port: port,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure()),
      ),
    );
  }

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
