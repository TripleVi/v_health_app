part of "map_cubit.dart";

@immutable
sealed class MapState {}

final class MapStateLoading extends MapState {}

final class MapStateLoaded extends MapState {
  final Set<Polyline> polylines;
  final Set<Marker> markers;
  final List<Photo> photos;
  final Photo? photoTapped;
  final bool markersVisible;

  MapStateLoaded({
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
    return MapStateLoaded(
      polylines: polylines ?? this.polylines,
      markers: markers ?? this.markers,
      photos: photos ?? this.photos,
      photoTapped: photoTapped,
      markersVisible: markersVisible ?? this.markersVisible,
    );
  }
}

final class MapStateError extends MapState {}