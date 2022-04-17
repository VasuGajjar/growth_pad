import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkInfo {
  final Connectivity connectivity;

  NetworkInfo(this.connectivity);

  Future<bool> get isConnected async {
    ConnectivityResult _result = await connectivity.checkConnectivity();
    return _result != ConnectivityResult.none;
  }

  static void checkConnectivity(BuildContext context) {
    bool first = true;
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      bool isNotConnected = result == ConnectivityResult.none;
      // isNotConnected ? const SizedBox() : ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (first && !isNotConnected) {
        first = false;
      } else {
        if (first) first = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 4000 : 2),
          content: Text(isNotConnected ? 'No Connection' : 'Connected', textAlign: TextAlign.center),
        ));
      }
    });
  }
}
