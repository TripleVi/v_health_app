part of 'notification_bloc.dart';

@immutable
abstract class NotificationState {
  const NotificationState();
}

class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

class NotificationLoaded extends NotificationState {
  final List<UserNotification> notifications;
  const NotificationLoaded(this.notifications);
}

class NotificationError extends NotificationState {
  final String message;
  const NotificationError([this.message = "Something went wrong. Please try again!"]);
}
