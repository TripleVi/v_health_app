import 'coordinate.dart';
import 'photo.dart';

class MapData {
  List<Coordinate> coordinates;
  List<Photo> photos;

  MapData({
    this.coordinates = const [],
    this.photos = const [],
  });
}