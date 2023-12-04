import '../../domain/entities/coordinate.dart';

class CoordinateRepo {
  
  Coordinate fromMap(Map<String, dynamic> map) {
    return Coordinate(latitude: map["latitude"], longitude: map["longitude"]);
  }

  Map<String, dynamic> toMap(Coordinate coordinate) {
    return {
      "latitude": coordinate.latitude,
      "longitude": coordinate.longitude,
    };
  }
}