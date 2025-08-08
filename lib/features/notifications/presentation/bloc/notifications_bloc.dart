import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc() : super(NotificationsInitial()) {
    on<NotificationsDataRequested>(_onNotificationsDataRequested);
    on<NotificationMarkedAsRead>(_onNotificationMarkedAsRead);
  }

  void _onNotificationsDataRequested(
    NotificationsDataRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(NotificationsLoading());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock notifications data
      final notifications = [
        {
          'id': '1',
          'title': 'Payment Successful',
          'message':
              'Your payment of Rp 50,000 has been processed successfully.',
          'time': '2 minutes ago',
          'isRead': false,
          'type': 'payment',
        },
        {
          'id': '2',
          'title': 'Welcome to SMARTMobs',
          'message':
              'Thank you for joining SMARTMobs! Start exploring our services.',
          'time': '1 hour ago',
          'isRead': true,
          'type': 'welcome',
        },
        {
          'id': '3',
          'title': 'Security Alert',
          'message': 'New login detected from Jakarta, Indonesia.',
          'time': '2 hours ago',
          'isRead': false,
          'type': 'security',
        },
        {
          'id': '4',
          'title': 'Service Update',
          'message': 'New features are now available in your SMARTMobs app.',
          'time': '1 day ago',
          'isRead': true,
          'type': 'update',
        },
      ];

      emit(NotificationsLoaded(notifications: notifications));
    } catch (e) {
      emit(NotificationsFailure(message: e.toString()));
    }
  }

  void _onNotificationMarkedAsRead(
    NotificationMarkedAsRead event,
    Emitter<NotificationsState> emit,
  ) {
    if (state is NotificationsLoaded) {
      final currentState = state as NotificationsLoaded;
      final updatedNotifications = List<Map<String, dynamic>>.from(
        currentState.notifications,
      );

      final index = updatedNotifications.indexWhere(
        (notification) => notification['id'] == event.notificationId,
      );
      if (index != -1) {
        updatedNotifications[index]['isRead'] = true;
        emit(NotificationsLoaded(notifications: updatedNotifications));
      }
    }
  }
}
