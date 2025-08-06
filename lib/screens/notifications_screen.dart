import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/core/di/injection.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Load notifications when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationsNotifierProvider.notifier).getNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationsState = ref.watch(notificationsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppColors.primaryRed,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () {
              // Mark all notifications as read
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All notifications marked as read'),
                ),
              );
            },
            child: const Text(
              'Mark all read',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: notificationsState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : notificationsState.error != null
          ? _buildErrorContent(notificationsState.error!)
          : _buildNotificationsContent(notificationsState.notifications),
    );
  }

  Widget _buildNotificationsContent(List<Map<String, dynamic>> notifications) {
    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    // Group notifications by date (today, this week, older)
    final todayNotifications = notifications.where((notification) {
      final date = DateTime.parse(
        notification['created_at'] ?? DateTime.now().toString(),
      );
      final now = DateTime.now();
      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
    }).toList();

    final weekNotifications = notifications.where((notification) {
      final date = DateTime.parse(
        notification['created_at'] ?? DateTime.now().toString(),
      );
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));
      return date.isAfter(weekAgo) &&
          !todayNotifications.contains(notification);
    }).toList();

    final olderNotifications = notifications.where((notification) {
      return !todayNotifications.contains(notification) &&
          !weekNotifications.contains(notification);
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (todayNotifications.isNotEmpty) ...[
          _buildSectionHeader('Today'),
          ...todayNotifications.map(
            (notification) => _buildNotificationTile(notification),
          ),
          const SizedBox(height: 24),
        ],
        if (weekNotifications.isNotEmpty) ...[
          _buildSectionHeader('This Week'),
          ...weekNotifications.map(
            (notification) => _buildNotificationTile(notification),
          ),
          const SizedBox(height: 24),
        ],
        if (olderNotifications.isNotEmpty) ...[
          _buildSectionHeader('Older'),
          ...olderNotifications.map(
            (notification) => _buildNotificationTile(notification),
          ),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textGray,
        ),
      ),
    );
  }

  Widget _buildNotificationTile(Map<String, dynamic> notification) {
    final isRead = notification['is_read'] ?? false;
    final type = notification['type'] ?? 'general';
    final title = notification['title'] ?? 'Notification';
    final message = notification['message'] ?? 'You have a new notification';
    final timestamp = DateTime.parse(
      notification['created_at'] ?? DateTime.now().toString(),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : AppColors.primaryRed.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isRead
              ? Colors.grey.withOpacity(0.2)
              : AppColors.primaryRed.withOpacity(0.2),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getNotificationColor(type).withOpacity(0.1),
          child: Icon(
            _getNotificationIcon(type),
            color: _getNotificationColor(type),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
            color: isRead ? AppColors.textGray : AppColors.textBlack,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isRead ? AppColors.textGray : AppColors.textBlack,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTimestamp(timestamp),
              style: const TextStyle(fontSize: 12, color: AppColors.textGray),
            ),
          ],
        ),
        trailing: !isRead
            ? Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primaryRed,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () {
          // Mark notification as read and handle tap
          _handleNotificationTap(notification);
        },
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
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
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
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(notificationsNotifierProvider.notifier)
                  .getNotifications();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Color _getNotificationColor(String type) {
    switch (type.toLowerCase()) {
      case 'success':
        return Colors.green;
      case 'warning':
        return Colors.orange;
      case 'error':
        return Colors.red;
      case 'info':
        return AppColors.primaryBlue;
      default:
        return AppColors.primaryRed;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'success':
        return Icons.check_circle;
      case 'warning':
        return Icons.warning;
      case 'error':
        return Icons.error;
      case 'info':
        return Icons.info;
      case 'payment':
        return Icons.payment;
      case 'transfer':
        return Icons.swap_horiz;
      default:
        return Icons.notifications;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  void _handleNotificationTap(Map<String, dynamic> notification) {
    // Handle notification tap
    // You can navigate to specific screens based on notification type
    final type = notification['type'] ?? 'general';

    switch (type.toLowerCase()) {
      case 'payment':
        // Navigate to payment screen
        break;
      case 'transfer':
        // Navigate to transfer screen
        break;
      default:
        // Show notification details
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(notification['title'] ?? 'Notification'),
            content: Text(notification['message'] ?? ''),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
    }
  }
}
