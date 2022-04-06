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
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      bool isNotConnected = result == ConnectivityResult.none;
      isNotConnected ? const SizedBox() : ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: isNotConnected ? Colors.red : Colors.green,
        duration: Duration(seconds: isNotConnected ? 6000 : 3),
        content: Text(isNotConnected ? 'no_connection' : 'connected', textAlign: TextAlign.center),
      ));
    });
  }
}
