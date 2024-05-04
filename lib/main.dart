import "dart:async";
import "dart:ui";

import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/services.dart";
import "package:flutter_background_service/flutter_background_service.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:geolocator/geolocator.dart";
import "package:permission_handler/permission_handler.dart";

import "core/resources/style.dart";
import "core/services/acceleration_service.dart";
import "core/services/location_service.dart";
import "core/services/sensor_service.dart";
import "core/utilities/constants.dart";
import "firebase_options.dart";
import "injector.dart";
import "presentation/auth/auth_page.dart";
import "presentation/site/views/site_page.dart";

@pragma("vm:entry-point")
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  // var rawAccelData = <List<double>>[];
  // final stream = await SensorService().accelerometerEvents();
  // stream.listen(rawAccelData.add);
  // Timer.periodic(const Duration(seconds: Constants.inactiveInterval), (_) async {
  //   final tempAccel = rawAccelData.toList();
  //   rawAccelData.clear();
  //   final service = AccelerationService();
  //   await service.updateReports(
  //     rawAccelData: tempAccel, 
  //     date: DateTime.now(),
  //   );
  // });

  service.on("trackingSessionCreated").listen((_) {
    StreamSubscription? appStateListener;
    StreamSubscription? locSessionListener;
    StreamSubscription? accelSessionListener;
    StreamSubscription? trackingStatesListener;
    final trackingStateStream = service.on("trackingStatesUpdated");
    var backgroundMode = false;
    // Service of location updates
    locSessionListener = service.on("locationUpdates").listen((_) {
      StreamSubscription? posListener;
      StreamSubscription? trStatesListener;
      var positions = <Map<String, dynamic>>[];
      StreamSubscription<Position> locationUpdatesHelper() {
        return LocationService().locationUpdates(Constants.distance).listen((p) {
          positions.add({
            "latitude": p.latitude,
            "longitude": p.longitude,
            "accuracy": p.accuracy,
            "timestamp": p.timestamp.millisecondsSinceEpoch,
          });
          if(backgroundMode) return;
          service.invoke("positionsAcquired", {"data": positions});
          positions = [];
        });
      }
      posListener = locationUpdatesHelper();
      trStatesListener = trackingStateStream.listen((data) {
        final state = data!["state"].toString();
        if(state == "resumed") {
          posListener = locationUpdatesHelper();
        }else if(state == "paused") {
          posListener!.cancel();
        }else if(state == "stopped") {
          posListener!.cancel();
          trStatesListener!.cancel();
        }
      });
    });
    // Service of acceleration sensors
    accelSessionListener = service.on("accelUpdates").listen((_) async {
      StreamSubscription? accelListener;
      StreamSubscription? trStatesListener;
      var signals = <List<double>>[];
      var accelAnalyzed = <Map<String, dynamic>>[];
      Timer? timer;
      Future<StreamSubscription<List<double>>> accelUpdatesHelper() async {
        final stream = await SensorService().accelerometerEvents();
        return stream.listen(signals.add);
      }
      Timer timerHelper() {
        return Timer.periodic(
            const Duration(seconds: Constants.activeInterval), (_) async {
              final tempAccel = signals.toList();
              signals.clear();
              final accelService = AccelerationService();
              final result = await accelService.analyze(tempAccel);
              accelAnalyzed.add(result);
              if(backgroundMode) return;
              service.invoke("accelAcquired", {"data": accelAnalyzed});
              accelAnalyzed = [];
            });
      }
      accelListener = await accelUpdatesHelper();
      timer = timerHelper();
      trStatesListener = trackingStateStream.listen((data) async {
        final state = data!["state"].toString();
        if(state == "resumed") {
          accelListener = await accelUpdatesHelper();
          timer = timerHelper();
        }else if(state == "paused") {
          timer!.cancel();
          accelListener!.cancel();
        }else if(state == "stopped") {
          timer!.cancel();
          accelListener!.cancel();
          trStatesListener!.cancel();
        }
      });
    });
    appStateListener = service.on("appStateUpdated").listen((data) {
      final appState = data!["state"].toString();
      if(appState == "paused") {
        backgroundMode = true;
      } else if(appState == "resumed") {
        backgroundMode = false;
      }
    });
    trackingStatesListener = trackingStateStream.listen((data) {
      final trackingState = data!["state"].toString();
      if(trackingState == "stopped") {
        appStateListener!.cancel();
        locSessionListener!.cancel();
        accelSessionListener!.cancel();
        trackingStatesListener!.cancel();
      }
    });
  });

  service.on("serviceStopped").listen((_) async => service.stopSelf());
}

final backgroundService = FlutterBackgroundService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth.instanceFor(app: app);
  initializeDependencies();
  await dotenv.load(fileName: ".env");

  await backgroundService.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
    ),
  );
  
  runApp(const VHealth());
}

class VHealth extends StatelessWidget {
  const VHealth({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "vHealth",
      theme: ThemeData().copyWith(
        colorScheme: ThemeData()
            .colorScheme.copyWith(primary: AppStyle.primaryColor),
      ),
      routes: {
        Routes.auth: (context) => AuthPage(),
        Routes.home: (context) => const SitePage(),
        // Routes.auth: (context) => const ActivityRecognition(),
        // Routes.auth: (context) => const LocationWidget(),
      },
      initialRoute: Routes.auth,
    );
  }
}

class LocationWidget extends StatefulWidget {
  const LocationWidget({super.key});

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> with WidgetsBindingObserver {
  StreamSubscription<Position>? subscriber;
  StreamSubscription? posListener;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        backgroundService.invoke("appStateUpdated", {
          "state": "resumed"
        });
        break;
      case AppLifecycleState.paused:
        backgroundService.invoke("appStateUpdated", {
          "state": "paused"
        });
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    backgroundService.on("positionsAcquired").listen((event) {
      final data = event!["data"] as List;
      print("Position: ${data.length}");
      print(data);
    });
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Location")),
        body: Column(
          children: [
            TextButton(
              onPressed: () async {
                backgroundService.invoke("trackingSessionCreated");
                backgroundService.invoke("locationUpdates");
                // backgroundService.invoke("accelUpdates");
              }, 
              child: const Text("Start")
            ),
            TextButton(
              onPressed: () async {
                backgroundService.invoke("trackingSessionCreated");
                backgroundService.invoke("locationUpdates");
                // backgroundService.invoke("accelUpdates");
              }, 
              child: const Text("Start")
            ),
            TextButton(
              onPressed: () async {
                backgroundService.invoke("trackingStatesUpdated", {
                  "state": "paused"
                });
              }, 
              child: const Text("Pause")
            ),
            TextButton(
              onPressed: () async {
                backgroundService.invoke("trackingStatesUpdated", {
                  "state": "resumed"
                });
              }, 
              child: const Text("Resume")
            ),
            TextButton(
              onPressed: () {
                // backgroundService.invoke("trackingStatesUpdated", {
                //   "state": "stopped"
                // });
                subscriber!.cancel();
              }, 
              child: const Text("Stop")
            ),
            TextButton(
              onPressed: () async {
                final service = await Geolocator.isLocationServiceEnabled();
                print(service);
                final permission = await Geolocator.checkPermission();
                print(permission);
                try {
                  final accuracy = await Geolocator.getLocationAccuracy();
                  print(accuracy);
                } catch (e) {
                  print(e.runtimeType);
                  print((e as PlatformException).code);
                }
              }, 
              child: const Text("Check")
            ),
            TextButton(
              onPressed: () async {
                // The location permission is denied by default. When requesting for the first time from installed, a dialog will be shown. If it's disallowed, the permission will be deniedForever. The permission dialog will no longer be shown.
                // There is no permission status which is deniedForever by default. Otherwise, the user disallows the permission. In this case, calling 'checkPermission' will return denied and 'requestPermission' will return deniedForever.
                // Co 2 lan hien thi
                // There is no option 'always' in the permission dialog. Hence, it's must be selected manually.
                // If the permission is allowed with an approximate accuracy in the permission dialog, 'Geolocator' won't show the accuracy dialog in the next request. Otherwise, 'PermissionHandler' will show this one. 
                // If the user doesn't select any option of the permission dialog including both approximate and precise accuracies, 'Geolocator' will return deniedForever and 'PermissionHandler' will return denied. If the permission dialog includes only the approximate accuracy, 'PermissionHandler' will return permanentlyDenied. In the case of the accuracy dialog, 'PermissionHandler' will return denied. The dialog is shown only if no options are selected and PermissionStatus.denied is returned.
                final result = await Geolocator.requestPermission();
                print(result);
              }, 
              child: const Text("Test1")
            ),
            TextButton(
              onPressed: () async {
                final result = await Permission.location.status;
                print(result);
                final result2 = await Permission.location.request();
                print(result2);
                // final result = await Geolocator.requestPermission();
                // print(result);
              }, 
              child: const Text("Test2")
            ),
          ],
        ),
      ),
    );
  }
}

class Routes {
  static const home = "/home";
  static const auth = "/auth";
}