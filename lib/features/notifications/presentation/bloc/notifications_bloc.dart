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
      await Future.delayed(const Duration(seconds: 1));

      final notifications = [
        {
          'id': '1',
          'title': 'Setor Tunai Berhasil',
          'message': 'Setor tunai Mesin CDM Rp. 123.000.000 berhasil diproses',
          'time': '2 menit yang lalu',
          'isRead': false,
          'type': 'deposit_success',
        },
        {
          'id': '2',
          'title': 'Setor Tunai Dalam Proses',
          'message':
              'Setor tunai Mesin CDM Rp. 5.500.000 masih dalam proses verifikasi',
          'time': '15 menit yang lalu',
          'isRead': false,
          'type': 'deposit_pending',
        },
        {
          'id': '3',
          'title': 'Setor Tunai Warung Berhasil',
          'message': 'Setor tunai Warung Grosir Rp. 500.000 berhasil diproses',
          'time': '1 jam yang lalu',
          'isRead': true,
          'type': 'deposit_success',
        },
        {
          'id': '4',
          'title': 'Pembayaran Listrik PLN',
          'message': 'Pembayaran listrik PLN Rp. 250.000 berhasil diproses',
          'time': '2 jam yang lalu',
          'isRead': true,
          'type': 'bill_payment',
        },
        {
          'id': '5',
          'title': 'Pulsa Berhasil',
          'message': 'Pembelian pulsa Rp. 100.000 untuk 08123456789 berhasil',
          'time': '3 jam yang lalu',
          'isRead': true,
          'type': 'pulsa_success',
        },
        {
          'id': '6',
          'title': 'Komisi Diterima',
          'message': 'Komisi Rp. 25.000 telah ditransfer ke saldo Anda',
          'time': '1 hari yang lalu',
          'isRead': true,
          'type': 'commission',
        },
        {
          'id': '7',
          'title': 'Maintenance Mesin CDM',
          'message': 'Mesin CDM di lokasi Anda sedang dalam maintenance',
          'time': '2 hari yang lalu',
          'isRead': true,
          'type': 'maintenance',
        },
        {
          'id': '8',
          'title': 'Selamat Datang di SMARTMobs',
          'message':
              'Terima kasih telah bergabung dengan SMARTMobs! Mulai jelajahi layanan kami',
          'time': '1 minggu yang lalu',
          'isRead': true,
          'type': 'welcome',
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
