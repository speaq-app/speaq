import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class BackendUtils {
  static String _host = "api.haveachin.de";
  static int _port = 443;

  static init({
    String? host,
  }) async {
    if (!kDebugMode) {
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
    } else {}
  }

  static String getHost() {
    return _host;
  }

  static int getPort() {
    return _port;
  }
}
