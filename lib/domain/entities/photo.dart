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

  factory Photo.empty() {
    return Photo(latitude: 0.0, longitude: 0.0, photoUrl: "");
  }

  @override
  String toString() {
    return "Photo{id: $id, latitude: $latitude, longitude: $longitude, photoUrl: $photoUrl}";
  }
}