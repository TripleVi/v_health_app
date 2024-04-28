part of 'activity_tracking_bloc.dart';

@immutable
sealed class ActivityTrackingEvent {
  const ActivityTrackingEvent();
}

class TrackingStarted extends ActivityTrackingEvent {
  final double? targetValue;
  const TrackingStarted(this.targetValue);
}

class TrackingPaused extends ActivityTrackingEvent {
  const TrackingPaused();
}

class TrackingResumed extends ActivityTrackingEvent {
  const TrackingResumed();
}

class TrackingFinished extends ActivityTrackingEvent {
  const TrackingFinished();
}

class TrackingSaved extends ActivityTrackingEvent {
  final bool? success;
  const TrackingSaved(this.success);
}

class TrackingDestroyed extends ActivityTrackingEvent {
  const TrackingDestroyed();
}

class LocationUpdated extends ActivityTrackingEvent {
  const LocationUpdated();
}

class PhotoMarkerTapped extends ActivityTrackingEvent {
  final io.File? photo;
  const PhotoMarkerTapped(this.photo);
}

class PictureTaken extends ActivityTrackingEvent {
  final PhotoParams params;
  const PictureTaken(this.params);
}

class PhotoDeleted extends ActivityTrackingEvent {
  final io.File file;
  const PhotoDeleted(this.file);
}

class DropDownItemSelected extends ActivityTrackingEvent {
  final TrackingTarget selectedItem;
  const DropDownItemSelected(this.selectedItem);
}

class PhotoEdited extends ActivityTrackingEvent {
  final Uint8List originalBytes;
  final Uint8List editedBytes;

  const PhotoEdited(this.originalBytes, this.editedBytes);
}

class MetricsUpdated extends ActivityTrackingEvent {

  const MetricsUpdated();
}

class RefreshScreen extends ActivityTrackingEvent {

  const RefreshScreen();
}

class CategorySelected extends ActivityTrackingEvent {
  final ActivityCategory category;

  const CategorySelected(this.category);
}

class OpenSettings extends ActivityTrackingEvent {
  final LocationSettingsRequest request;

  const OpenSettings(this.request);
}

class ToggleMetricsDialog extends ActivityTrackingEvent {
  const ToggleMetricsDialog();
}

class TogglePage extends ActivityTrackingEvent {
  const TogglePage();
}