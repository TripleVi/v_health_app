part of 'map_cubit.dart';

@immutable
final class MapState {
  final Set<Polyline> polylines;
  final Set<Marker> markers;
  final List<Photo> photos;
  final Photo? photoTapped;
  final bool markersVisible;

  const MapState({
    this.polylines = const {},
    this.markers = const {},
    this.photos = const [],
    this.photoTapped,
    this.markersVisible = true,
  });

  MapState copyWith({
    Set<Polyline>? polylines,
    Set<Marker>? markers,
    List<Photo>? photos,
    Photo? photoTapped,
    bool? markersVisible,
  }) {
    return MapState(
      polylines: polylines ?? this.polylines,
      markers: markers ?? this.markers,
      photos: photos ?? this.photos,
      photoTapped: photoTapped,
      markersVisible: markersVisible ?? this.markersVisible,
    );
  }
}