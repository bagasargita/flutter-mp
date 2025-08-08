part of 'notifications_bloc.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

class NotificationsLoaded extends NotificationsState {
  final List<Map<String, dynamic>> notifications;

  const NotificationsLoaded({required this.notifications});

  @override
  List<Object> get props => [notifications];
}

class NotificationsFailure extends NotificationsState {
  final String message;

  const NotificationsFailure({required this.message});

  @override
  List<Object> get props => [message];
}
