class Coordinate {
  double latitude;
  double longitude;

  Coordinate({required this.latitude, required this.longitude});

  factory Coordinate.fromMap(Map<String, dynamic> map) {
    return Coordinate(
      latitude: map["latitude"] * 1.0, 
      longitude: map["longitude"] * 1.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "latitude": latitude,
      "longitude": longitude,
    };
  }

  @override
  String toString() {
    return "Coordinate{latitude: $latitude, longitude: $longitude}";
  }
}