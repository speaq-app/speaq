import 'package:fixnum/fixnum.dart';
import 'package:frontend/api/grpc/protos/resource.pbgrpc.dart';
import 'package:frontend/api/model/resource.dart';
import 'package:frontend/api/resource_service.dart';
import 'package:frontend/utils/token_utils.dart';
import 'package:grpc/grpc.dart';

class GRPCResourceService implements ResourceService {
  late ResourceClient _client;
  late CallOptions _callOptions;

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

    var token = TokenUtils.getToken();
    _callOptions = CallOptions(metadata: {"authorization": "bearer $token"});
  }

  @override
  Future<Resource> getResource(int id) async {
    GetResourceResponse resp = await _client.getResource(
      GetResourceRequest()..id = Int64(id),
      options: _callOptions,
    );

    return Resource(
      id: id,
      data: resp.data,
      mimeType: resp.mimeType,
      audioDurationInMillis: resp.audioDuration.toInt(),
    );
  }
}
