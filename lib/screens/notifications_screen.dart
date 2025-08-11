import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/constants/app_text.dart';
import 'package:smart_mob/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:smart_mob/widgets/common/app_top_bar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationsBloc(),
      child: MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(1.0)),
        child: BlocListener<NotificationsBloc, NotificationsState>(
          listener: (context, state) {},
          child: BlocBuilder<NotificationsBloc, NotificationsState>(
            builder: (context, state) {
              if (state is NotificationsInitial) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    context.read<NotificationsBloc>().add(
                      const NotificationsDataRequested(),
                    );
                  }
                });
              }

              return Scaffold(
                backgroundColor: AppColors.backgroundWhite,
                body: SafeArea(
                  child: Column(
                    children: [
                      const AppTopBar(title: 'Notifications', showBack: true),
                      Expanded(child: _buildNotificationsContent(state)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsContent(NotificationsState state) {
    if (state is NotificationsLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is NotificationsLoaded) {
      return _buildNotificationsList(state.notifications);
    } else if (state is NotificationsFailure) {
      return _buildErrorContent(state.message);
    } else {
      return _buildEmptyState();
    }
  }

  Widget _buildNotificationsList(List<Map<String, dynamic>> notifications) {
    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationItem(
          notification['title'] as String,
          notification['message'] as String,
          notification['time'] as String,
          notification['isRead'] as bool,
          notification['type'] as String,
          notification['id'] as String,
        );
      },
    );
  }

  Widget _buildNotificationItem(
    String title,
    String message,
    String time,
    bool isRead,
    String type,
    String id,
  ) {
    IconData iconData;
    Color iconColor;

    switch (type) {
      case 'deposit_success':
        iconData = Icons.account_balance;
        iconColor = Colors.green;
        break;
      case 'deposit_pending':
        iconData = Icons.pending;
        iconColor = Colors.orange;
        break;
      case 'bill_payment':
        iconData = Icons.electric_bolt;
        iconColor = Colors.blue;
        break;
      case 'pulsa_success':
        iconData = Icons.phone_android;
        iconColor = Colors.purple;
        break;
      case 'commission':
        iconData = Icons.monetization_on;
        iconColor = Colors.amber;
        break;
      case 'maintenance':
        iconData = Icons.build;
        iconColor = Colors.red;
        break;
      case 'welcome':
        iconData = Icons.celebration;
        iconColor = Colors.pink;
        break;
      default:
        iconData = Icons.notifications;
        iconColor = AppColors.primaryRed;
    }

    return GestureDetector(
      onTap: () {
        if (!isRead) {
          context.read<NotificationsBloc>().add(NotificationMarkedAsRead(id));
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isRead ? Colors.white : Colors.blue.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isRead
                ? Colors.grey[200]!
                : Colors.blue.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: AppText.bodyMedium.copyWith(
                            color: AppColors.textBlack,
                            fontWeight: isRead
                                ? FontWeight.normal
                                : FontWeight.w600,
                          ),
                          textScaler: TextScaler.linear(1.0),
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: AppText.bodySmall.copyWith(
                      color: AppColors.textGray,
                      fontWeight: isRead ? FontWeight.normal : FontWeight.w500,
                    ),
                    textScaler: TextScaler.linear(1.0),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    time,
                    style: AppText.bodySmall.copyWith(
                      color: AppColors.textGray,
                      fontSize: 12,
                    ),
                    textScaler: TextScaler.linear(1.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No notifications',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            textScaler: TextScaler.linear(1.0),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
            textScaler: TextScaler.linear(1.0),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorContent(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.primaryRed,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load notifications',
            style: const TextStyle(fontSize: 18),
            textScaler: TextScaler.linear(1.0),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
            textScaler: TextScaler.linear(1.0),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<NotificationsBloc>().add(
                const NotificationsDataRequested(),
              );
            },
            child: Text('Retry', textScaler: TextScaler.linear(1.0)),
          ),
        ],
      ),
    );
  }
}
