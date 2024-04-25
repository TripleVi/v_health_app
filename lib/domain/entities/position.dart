class AppPosition {
  double latitude;
  double longitude;
  double accuracy;

  AppPosition(this.latitude, this.longitude, this.accuracy);

  factory AppPosition.fromMap(Map<String, dynamic> map) {
    return AppPosition(map["latitude"]*1.0, map["longitude"]*1.0, map["accuracy"]*1.0);
  }

  @override
  String toString() {
    return "Position{latitude: $latitude, longitude: $longitude, accuracy: $accuracy}";
  }
}