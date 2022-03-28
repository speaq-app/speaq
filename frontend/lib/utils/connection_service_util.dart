import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectionUtilSingleton {
  //This creates the single instance by calling the `_internal` constructor specified below
  static final ConnectionUtilSingleton _singleton = ConnectionUtilSingleton._internal();

  ConnectionUtilSingleton._internal();

  //This is what's used to retrieve the instance through the app
  static ConnectionUtilSingleton getInstance() => _singleton;

  //This tracks the current connection status
  bool hasConnection = false;

  //This is how we'll allow subscribing to connection changes
  StreamController connectionChangeController = StreamController.broadcast();

  //flutter_connectivity
  final Connectivity _connectivity = Connectivity();

  //Hook into flutter_connectivity's Stream to listen for changes
  //And check the connection status out of the gate
  void initialize() {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
  }

  //flutter_connectivity's listener
  void _connectionChange(ConnectivityResult result) {
    _hasInternetInternetConnection();
  }

  Stream get connectionChange => connectionChangeController.stream;

  //The test to actually see if there is a connection
  Future<bool> _hasInternetInternetConnection() async {
    bool previousConnection = hasConnection;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
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
}
