import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_connection_interface.dart';

class BackendUtils {
  static String _host = "api.speaq.app";
  static int _port = 1337;

  static init({
    String? host,
  }) async {
    if (kDebugMode) {
      //In order to use locally
      // if (kDebugMode) { //In order to access server
      return;
    }

    _port = 8080;
    _host = "localhost";
    if (host != null) {
      _host = host;
      return;
    }

    if (kIsWeb) {
      return;
    }

    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      final isPhysicalDevice = deviceInfo.isPhysicalDevice ?? true;
      if (!isPhysicalDevice) {
        _host = "10.0.2.2";
      }
    }
  }

  static String getHost() {
    return _host;
  }

  static int getPort() {
    return _port;
  }

  static ClientChannelBase createClientChannel() {
    return ClientChannel(
      _host,
      port: _port,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
  }
}
