// import 'dart:async';

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/services.dart';

// class ConnectionService {
//   ConnectionService.init();
//   final Connectivity _connectivity = Connectivity();
//   late StreamSubscription<ConnectivityResult> _connectivitySubscription;
//   static final ConnectionService instance = ConnectionService.init();
//   static ConnectivityResult _connectionStatus = ConnectivityResult.none;

//   bool isConnected() {
//     return _connectionStatus != ConnectivityResult.none;
//   }

//   void attach() {
//     initConnectivity();
//     _connectivitySubscription =
//         _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
//     print('Connected to connection service');
//   }

//   Future<void> initConnectivity() async {
//     late ConnectivityResult result;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       result = await _connectivity.checkConnectivity();
//     } on PlatformException catch (e) {
//       return;
//     }
//     return _updateConnectionStatus(result);
//   }

//   Future<void> _updateConnectionStatus(ConnectivityResult result) async {
//     _connectionStatus = result;
//   }

//   void dispose() {
//     _connectivitySubscription.cancel();
//   }
// }
