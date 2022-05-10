import 'package:frontend/api/grpc/protos/google/protobuf/empty.pb.dart';
import 'package:frontend/api/grpc/protos/settings.pbgrpc.dart';
import 'package:frontend/api/settings_service.dart';
import 'package:grpc/grpc.dart';

class GRPCSettingsService implements SettingsService {
  late SettingsClient _client;

  GRPCSettingsService(
    String ip, {
    int port = 443,
  }) {
    _client = SettingsClient(
      ClientChannel(
        ip,
        port: port,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure()),
      ),
    );
  }

  @override
  Future<Uri> getImprintURL() async {
    GetImprintResponse resp = await _client.getImprintURL(Empty());
    return Uri.parse(resp.url);
  }
}
