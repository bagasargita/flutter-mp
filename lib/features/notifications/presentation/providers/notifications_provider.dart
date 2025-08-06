import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_mob/features/notifications/domain/usecases/get_notifications_usecase.dart';

class NotificationsState {
  final bool isLoading;
  final List<Map<String, dynamic>> notifications;
  final String? error;

  const NotificationsState({
    this.isLoading = false,
    this.notifications = const [],
    this.error,
  });

  NotificationsState copyWith({
    bool? isLoading,
    List<Map<String, dynamic>>? notifications,
    String? error,
  }) {
    return NotificationsState(
      isLoading: isLoading ?? this.isLoading,
      notifications: notifications ?? this.notifications,
      error: error,
    );
  }
}

class NotificationsNotifier extends StateNotifier<NotificationsState> {
  final GetNotificationsUseCase _getNotificationsUseCase;

  NotificationsNotifier({
    required GetNotificationsUseCase getNotificationsUseCase,
  }) : _getNotificationsUseCase = getNotificationsUseCase,
       super(const NotificationsState());

  Future<void> getNotifications() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _getNotificationsUseCase();

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (notifications) {
        state = state.copyWith(isLoading: false, notifications: notifications);
      },
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
