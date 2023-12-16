import 'base_entity.dart';

class Photo extends BaseEntity {
  double latitude;
  double longitude;
  String photoUrl;

  Photo({
    super.id,
    required this.latitude,
    required this.longitude,
    required this.photoUrl,
  });

  factory Photo.fromMap(Map<String, dynamic> map) {
    return Photo(
      id: map["pid"],
      latitude: map["latitude"] * 1.0, 
      longitude: map["longitude"] * 1.0, 
      photoUrl: map["photoUrl"]
    );
  }

  factory Photo.empty() {
    return Photo(latitude: 0.0, longitude: 0.0, photoUrl: "");
  }

  @override
  String toString() {
    return "Photo{id: $id, latitude: $latitude, longitude: $longitude, photoUrl: $photoUrl}";
  }
}