import 'dart:async';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utils/token_utils.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

/// Goes back to the origin of the widget tree and calls the login page.
void logOut(BuildContext context) {
  TokenUtils.setToken(null).then((_) {
    Navigator.popUntil(context, ModalRoute.withName("main"));
    Navigator.pushNamed(context, 'main');
  });
}

class ConnectionUtilSingleton {
  /// Creates the single instance by calling the [ConnectionUtilSingleton._internal()] constructor specified below.
  static final ConnectionUtilSingleton _singleton =
      ConnectionUtilSingleton._internal();

  ConnectionUtilSingleton._internal();

  ///  Retrieve the instance through the app.
  static ConnectionUtilSingleton getInstance() => _singleton;

  /// Tracks the current connection status.
  bool hasConnection = false;

  /// Subscribing to connection changes.
  StreamController connectionChangeController = StreamController.broadcast();

  final Connectivity _connectivity = Connectivity();

  /// Hook into flutter_connectivity's Stream to listen for changes and check the connection status out of the gate.
  void initialize() {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
  }

  /// Flutter_connectivity's listener.
  void _connectionChange(ConnectivityResult result) {
    _hasInternetInternetConnection();
  }

  Stream get connectionChange => connectionChangeController.stream;

  /// Tests if there is a [_connectivity].
  Future<bool> _hasInternetInternetConnection() async {
    bool previousConnection = hasConnection;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // this is the different
      if (await InternetConnectionChecker().hasConnection) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } else {
      hasConnection = false;
    }

    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }
    return hasConnection;
  }

  static noConnectionDialog(BuildContext context) {
    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("NO INTERNET CONNECTION"),
          content: const Text("Please check your device settings"),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 10.0),
          buttonPadding: const EdgeInsets.symmetric(horizontal: 15.0),
          actions: <Widget>[
            ElevatedButton(
              child: const Text(
                "Settings",
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed: () => AppSettings.openDeviceSettings(
                asAnotherTask: true,
              ),
            ),
            ElevatedButton(
              child: const Text("OK", style: TextStyle(fontSize: 20.0)),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ],
        ),
      );
    }

    // Todo : ShowDialog for ios
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("NO INTERNET CONNECTION"),
        content: const Text("Please check your device settings"),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text(
              "Settings",
              style: TextStyle(fontSize: 20.0),
            ),
            onPressed: () => AppSettings.openDeviceSettings(
              asAnotherTask: true,
            ),
          ),
          CupertinoDialogAction(
            child: const Text("OK"),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );
  }
}
