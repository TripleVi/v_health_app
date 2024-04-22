import "dart:async";

import "package:geolocator/geolocator.dart";

class PermissionResponse {
  final bool isServiceEnabled;
  final LocationAccuracyStatus accuracyStatus;
  final LocationPermission permission;

  PermissionResponse({
    this.isServiceEnabled = false,
    this.accuracyStatus = LocationAccuracyStatus.reduced,
    this.permission = LocationPermission.deniedForever,
  });

  bool get isPrecise => accuracyStatus == LocationAccuracyStatus.precise;
  bool get isDenied => permission == LocationPermission.denied;
  bool get isDeniedForever => permission == LocationPermission.deniedForever;
} 

class LocationService {
  LocationService();

  Future<PermissionResponse> requestPermission() async {
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!isServiceEnabled) {
      return PermissionResponse();
    }

    var permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied) {
        return PermissionResponse(
          isServiceEnabled: isServiceEnabled,
          permission: permission,
        );
      }
    }
    if(permission == LocationPermission.deniedForever) {
      return PermissionResponse(
        isServiceEnabled: isServiceEnabled,
        permission: permission,
      );
    }
    
    var accuracyStatus = await Geolocator.getLocationAccuracy();
    if(accuracyStatus != LocationAccuracyStatus.precise) {
      await Geolocator.requestPermission();
    }
    accuracyStatus = await Geolocator.getLocationAccuracy();
    return PermissionResponse(
      isServiceEnabled: isServiceEnabled,
      permission: permission,
      accuracyStatus: accuracyStatus,
    );
  }

  static Future<void> openLocationSettings() {
    return Geolocator.openLocationSettings();
  }

  static Future<void> openAppSettings() {
    return Geolocator.openAppSettings();
  }

  Future<Position?> getCurrentPosition() async {
    try {
      return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
    } on LocationServiceDisabledException {
      return null;
    } catch (e) {
      rethrow;
    }
  }

  double distanceBetween(
    double startLatitude, double startLongitude,
    double endLatitude, double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude, startLongitude, endLatitude, endLongitude,
    );
  }

  Stream<Position> locationUpdates([int distanceFilter = 0]) {
    LocationSettings? locationSettings;

    // if (defaultTargetPlatform == TargetPlatform.android) {
    //   print("Android setting platform");
    //   locationSettings = AndroidSettings(
    //     accuracy: LocationAccuracy.high,
    //     distanceFilter: distanceFilter,
    //     // intervalDuration: const Duration(seconds: 10),
    //     //(Optional) Set foreground notification config to keep the app alive 
    //     //when going to the background
    //     foregroundNotificationConfig: const ForegroundNotificationConfig(
    //         notificationText:
    //         "Example app will continue to receive your location even when you aren't using it",
    //         notificationTitle: "Running in Background",
    //         enableWakeLock: true,
    //     ),
    //   );
    // } 
    // else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
    //   locationSettings = AppleSettings(
    //     accuracy: LocationAccuracy.high,
    //     activityType: ActivityType.fitness,
    //     distanceFilter: distanceFilter,
    //     pauseLocationUpdatesAutomatically: false,
    //     // Only set to true if our app will be started up in the background.
    //     showBackgroundLocationIndicator: false,
        
    //   );
    // } else {
      locationSettings = LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: distanceFilter,
      );
    // }
    
    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  static Future<void> getAddressFromPosition({
    required double latitude, 
    required double longitude,
    String localeIdentifier = "en",
  }) async {
    // final placemarks =  await geocoding.placemarkFromCoordinates(
    //   latitude, 
    //   longitude, 
    //   // localeIdentifier: localeIdentifier,
    // );

    // return ReverseGeocodingResponse(
    //   country: placemarks.first.country!,
    //   administrativeArea: placemarks.first.administrativeArea!,
    // );
  }
}

class ReverseGeocodingResponse {
  final String country;
  final String administrativeArea;

  const ReverseGeocodingResponse({
    required this.country,
    required this.administrativeArea,
  }); 
}