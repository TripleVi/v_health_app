// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get_it/get_it.dart';

// import '../../../data/repositories/user_repo.dart';
// import '../../../domain/entities/user_notification.dart';
// import '../../../domain/usecases/notification/fetch_notifications.dart';

// part 'notification_event.dart';
// part 'notification_state.dart';

// class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
//   StreamSubscription<List<UserNotification>>? _subscriber;

//   NotificationBloc() : super(const NotificationLoading()) {
//     on<NotificationsFetched>(_onNotificationsFetched);

//     GetIt.instance<UserRepo>().getUserSession().then((user) {
//       final useCase = GetIt.instance<FetchNotificationsUseCase>();
//       _subscriber = useCase(params: user.id).listen((event) {
//         print("Length: ${event.length}");
//         add(NotificationsFetched(event));
//       });
//     });
//   }

//   void _onNotificationsFetched(
//     NotificationsFetched event,
//     Emitter<NotificationState> emit,
//   ) {
//     emit(NotificationLoaded(event.notifications));
//   }

//   @override
//   Future<void> close() async {
//     await _subscriber?.cancel();
//     return super.close();
//   }
// }
