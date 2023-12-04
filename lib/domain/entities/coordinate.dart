class Coordinate {
  double latitude;
  double longitude;

  Coordinate({required this.latitude, required this.longitude});

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