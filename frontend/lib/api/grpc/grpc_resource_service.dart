import 'package:fixnum/fixnum.dart';
import 'package:frontend/api/grpc/protos/resource.pbgrpc.dart';
import 'package:grpc/grpc.dart';

abstract class GRPCResourceService {
  static final ResourceClient _client = ResourceClient(
    ClientChannel(
      "10.0.2.2",
      port: 8080,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    ),
  );

  static Future<ResourceResponse> getResource(int id) async {
    return _client.getResource(
      ResourceRequest()..iD = Int64(id),
    );
  }
}
