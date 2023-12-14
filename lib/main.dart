import 'dart:async';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:v_health/domain/entities/comment.dart';
import 'package:v_health/presentation/camera/views/camera_page.dart';

import 'core/services/classifer_service.dart';
import 'core/services/location_service.dart';
import 'core/services/sensor_service.dart';
import 'core/utilities/utils.dart';
import 'data/sources/api/post_service.dart';
import 'data/sources/api/user_api.dart';
import 'domain/entities/post.dart';
import 'domain/entities/user.dart' as u;
import 'firebase_options.dart';
import 'injector.dart';
import 'presentation/auth/auth_page.dart';
import 'presentation/site/views/site_page.dart';

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  // var rawAccelData = <List<double>>[];
  // final stream = await SensorService().accelerometerEvents();
  // final subscriber = stream.listen((event) {
  //   rawAccelData.add(event);
  // });
  // service.on("stationary").listen((event) {
  //   subscriber.pause();
  // });
  // service.on("moving").listen((event) {
  //   subscriber.resume();
  // });
  // const analysisInterval = 15;
  // Timer.periodic(const Duration(seconds: analysisInterval), (_) async {
  //   final temp = rawAccelData.toList(growable: false);
  //   rawAccelData.clear();
  //   final classifierService = ClassifierService();
  //   await classifierService.generateReport(
  //     rawAccelData: temp, 
  //     date: MyUtils.getCurrentDateAsSqlFormat(), 
  //     samplingRate: rawAccelData.length / analysisInterval,
  //   );
  // });

  StreamSubscription? posSubscriber;
  service.on("trackingStarted").listen((_) {
    posSubscriber = LocationService().locationUpdates(5).listen((event) {
      service.invoke("positionAcquired", {"position": event});
    }, onError: (_) async {
      await posSubscriber!.cancel();
      posSubscriber = null;
      service.invoke("trackingError");
    });
  });
  service.on("trackingResumed").listen((_) => posSubscriber!.resume());
  service.on("trackingPaused").listen((_) => posSubscriber!.pause());
  service.on("trackingStopped").listen((_) async {
    await posSubscriber!.cancel();
    posSubscriber = null;
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
      routes: {
        Routes.home: (context) => const SitePage(),
        Routes.auth: (context) => AuthPage(),
        // Routes.auth: (context) => Container(
        //   width: double.infinity,
        //   height: double.infinity,
        //   color: Colors.white,
        //   child: Center(
        //     child: Row(
        //       children: [
        //         TextButton(child: const Text("Press me"), onPressed: () async {
        //           // final service = PostService();
        //           final a = StreamController<int>(onPause: () {
        //             print("onPaused");
        //           }, onResume: () {
        //             print("oonResumed");
        //           }, onCancel: () {
        //             print("onCanceled");
        //           },);
        //           sub = a.stream.listen((event) {
        //             print("data: $event");
        //           }, onDone: () {
        //             print("Stream done");
        //           },);
        //           a.sink.add(10);
        //           await Future.delayed(Duration(seconds: 2));
        //           // sub!.pause();
        //           await Future.delayed(Duration(seconds: 2));
        //           final result = await a.close();
        //           print(result);
        //           a.sink.add(20);
        //         }),
        //         TextButton(child: const Text("Press me2"), onPressed: () async {
        //           sub!.resume();
        //           // await sub!.cancel();
        //           // print(result);
        //         }),
        //       ],
        //     ),
        //   ),
        // ),
      },
      initialRoute: Routes.auth,
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
