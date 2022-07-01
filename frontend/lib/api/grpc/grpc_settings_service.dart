import 'package:frontend/api/grpc/protos/google/protobuf/empty.pb.dart';
import 'package:frontend/api/grpc/protos/settings.pbgrpc.dart';
import 'package:frontend/api/settings_service.dart';
import 'package:frontend/utils/token_utils.dart';
import 'package:grpc/grpc_connection_interface.dart';

class GRPCSettingsService implements SettingsService {
  late SettingsClient _client;
  late CallOptions _callOptions;

  GRPCSettingsService(ClientChannelBase channel) {
    _client = SettingsClient(channel);
    var token = TokenUtils.getToken();
    _callOptions = CallOptions(metadata: {"authorization": "bearer $token"});
  }

  @override
  Future<Uri> getImprintURL() async {
    GetImprintResponse resp = await _client.getImprintURL(
      Empty(),
      options: _callOptions,
    );
    return Uri.parse(resp.url);
  }
}
