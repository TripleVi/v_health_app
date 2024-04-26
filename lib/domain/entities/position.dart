class AppPosition {
  double latitude;
  double longitude;
  double accuracy;
  DateTime timestamp;

  AppPosition({
    required this.latitude, 
    required this.longitude, 
    required this.accuracy, 
    required this.timestamp,
  });

  factory AppPosition.fromMap(Map<String, dynamic> map) {
    return AppPosition(
      latitude: map["latitude"]*1.0, 
      longitude: map["longitude"]*1.0, 
      accuracy: map["accuracy"]*1.0,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map["timestamp"]),
    );
  }

  @override
  String toString() {
    return "Position{latitude: $latitude, longitude: $longitude, accuracy: $accuracy, timestamp: $timestamp}";
  }
}