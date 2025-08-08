part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

class NotificationsDataRequested extends NotificationsEvent {
  const NotificationsDataRequested();
}

class NotificationMarkedAsRead extends NotificationsEvent {
  final String notificationId;

  const NotificationMarkedAsRead(this.notificationId);

  @override
  List<Object> get props => [notificationId];
}
