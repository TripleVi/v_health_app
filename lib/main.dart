import 'dart:async';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'core/services/classification_service.dart';
import 'core/services/location_service.dart';
import 'core/services/sensor_service.dart';
import 'firebase_options.dart';
import 'injector.dart';
import 'presentation/auth/auth_page.dart';
import 'presentation/site/views/site_page.dart';

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // DartPluginRegistrant.ensureInitialized();
  // var rawAccelData = <List<double>>[];
  // final stream = await SensorService().accelerometerEvents();
  // stream.listen((event) {
  //   rawAccelData.add(event);
  // });
  // const inactiveInterval = 15;
  // Timer.periodic(const Duration(seconds: inactiveInterval), (_) async {
  //   final temp = rawAccelData.toList(growable: false);
  //   rawAccelData.clear();
  //   final service = ClassificationService();
  //   await service.updateReports(
  //     rawAccelData: temp, 
  //     date: DateTime.now(),
  //     samplingRate: temp.length/inactiveInterval,
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
      final positions = <Position>[];
      StreamSubscription<Position> locationUpdatesHelper() {
        return LocationService().locationUpdates(5).listen((p) {
          if(backgroundMode) return positions.add(p);
          if(positions.isEmpty) {
            return service.invoke("positionsAcquired", {"data": [p]});
          }
          final temp = positions.toList();
          positions.clear();
          service.invoke("positionsAcquired", {"data": temp});
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
      final signals = <List<double>>[];
      Timer? timer;
      Future<StreamSubscription<List<double>>> accelUpdatesHelper() async {
        final stream = await SensorService().accelerometerEvents();
        return stream.listen(signals.add);
      }
      Timer timerHelper() {
        return Timer.periodic(const Duration(seconds: activeInterval), (_) {
          if(backgroundMode) return;
          final temp = signals.toList(growable: false);
          signals.clear();
          return service.invoke("accelAcquired", {"data": temp});
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
const activeInterval = 5; // seconds
StreamSubscription<Map<String, dynamic>?>? locSubscriber;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth.instanceFor(app: app);
  initializeDependencies();

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
  
  // await backgroundService.startService();
  runApp(const VHealth());
}

class VHealth extends StatelessWidget {
  const VHealth({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "vHealth",
      routes: {
        Routes.home: (context) => const SitePage(),
        Routes.auth: (context) => AuthPage(),
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
    print("build");
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
  static const registration = "/register";
  static const recovery = "/recovery";
  static const userDetails = "/details";
  static const dailyStats = "/statistics";
  static const tracking = "/tracking";
}

class ActivityRecognition extends StatefulWidget {
  const ActivityRecognition({super.key});

  @override
  State<ActivityRecognition> createState() => _ActivityRecognitionState();
}

class _ActivityRecognitionState extends State<ActivityRecognition> {
  StreamSubscription<Activity>? _activityStreamSubscription;
  final activities = <Activity>[];
  final timeFrames = <DateTime>[];

  var rawAccelData = <List<double>>[];
  final sTimeFrames = <DateTime>[];
  StreamSubscription<List<double>>? sensorSubscriber;
  List<Map<String, dynamic>> accelResult = [];

  // void _handleError(dynamic error) {
  //   print(error);
  // }

  // Future<void> processSensor() async {
  //   final stream = await SensorService().accelerometerEvents();
  //   sensorSubscriber = stream.listen((event) {
  //     rawAccelData.add([event[0]/9.8, event[1]/9.8, event[2]/9.8]);
  //     sTimeFrames.add(DateTime.now());
  //   });
  //   sensorSubscriber.pause();
  // }

  @override
  void initState() {
    super.initState();
    

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   final activityRecognition = FlutterActivityRecognition.instance;

    //   // Check if the user has granted permission. If not, request permission.
    //   PermissionRequestResult reqResult;
    //   reqResult = await activityRecognition.checkPermission();
    //   if (reqResult == PermissionRequestResult.PERMANENTLY_DENIED) {
    //     print('Permission is permanently denied.');
    //     return;
    //   } else if (reqResult == PermissionRequestResult.DENIED) {
    //     reqResult = await activityRecognition.requestPermission();
    //     if (reqResult != PermissionRequestResult.GRANTED) {
    //       print('Permission is denied.');
    //       return;
    //     }
    //   }
    //   // Subscribe to the activity stream.
    //   _activityStreamSubscription = activityRecognition.activityStream
    //       .handleError(_handleError)
    //       .listen(_onActivityReceive);

      // final service = LocationService();
      // final result = await service.requestPermission();
      // print(result.isPrecise);
      // backgroundService.invoke("trackingStarted");

      // backgroundService.on("positionAcquired").listen((event) {
      //   print("Location: $event");
      // },);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Activity Recognition'),
          centerTitle: true
        ),
        body: _buildContentView()
      ),
    );
  }

  @override
  void dispose() {
    _activityStreamSubscription?.cancel();
    super.dispose();
  }

  Widget _buildContentView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextButton(
            onPressed: () async {
              await _activityStreamSubscription?.cancel();
              _activityStreamSubscription = null;
              _activityStreamSubscription = FlutterActivityRecognition.instance.activityStream
              .listen((event) {
                print(event);
                activities.add(event);
                timeFrames.add(DateTime.now());
              },);
              print(activities.length);
              rawAccelData.clear();
              sTimeFrames.clear();
              accelResult.clear();
              setState(() {});
              final stream = await SensorService().accelerometerEvents();
              sensorSubscriber = stream.listen((event) {
                rawAccelData.add([event[0]/9.8, event[1]/9.8, event[2]/9.8]);
                sTimeFrames.add(DateTime.now());
              });
              Future.delayed(const Duration(seconds: 1)).then((value) => print("sample r: ${rawAccelData.length}"));
              await Future.delayed(const Duration(seconds: 15));
              print("Length: ${rawAccelData.length} - ${activities.length}");
              final samplingRate = rawAccelData.length / 15;
              print("Sampling rate: $samplingRate");
              final classifierService = ClassificationService();
              sensorSubscriber?.cancel();
              sensorSubscriber = null;
              accelResult = classifierService.test(rawAccelData, sTimeFrames, samplingRate);
              print("Done");
              setState(() {});
            }, 
            child: const Text("Press me")
          ),
          Text("Steps: "),
          const SizedBox(height: 12.0),
          SizedBox(
            height: 300,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(8.0),
              itemCount: accelResult.length,
              itemBuilder: (context, index) {
                final result = accelResult[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "$result", 
                    style: const TextStyle(fontSize: 12.0),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 50,),
          SizedBox(
            height: 300,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(8.0),
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                final time = timeFrames[index];
                final content = activity.toJson().toString();
                return Container(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    "$time - $content", 
                    style: const TextStyle(fontSize: 16.0),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}