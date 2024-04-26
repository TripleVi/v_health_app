import "dart:async";

import "package:geolocator/geolocator.dart";

import "../../domain/entities/position.dart";

class LocationService {
  LocationService();

  static Future<void> openLocationSettings() {
    return Geolocator.openLocationSettings();
  }

  static Future<void> openAppSettings() {
    return Geolocator.openAppSettings();
  }

  Future<AppPosition?> getCurrentPosition() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      return AppPosition(pos.latitude, pos.longitude, pos.accuracy, pos.timestamp);
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