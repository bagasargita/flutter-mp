import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/constants/app_text.dart';
import 'package:smart_mob/features/notifications/presentation/bloc/notifications_bloc.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsBloc>().add(const NotificationsDataRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: BlocProvider(
        create: (context) => NotificationsBloc(),
        child: BlocBuilder<NotificationsBloc, NotificationsState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: AppColors.backgroundWhite,
              body: SafeArea(
                child: Column(
                  children: [
                    _buildTopBar(),
                    Expanded(child: _buildNotificationsContent(state)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.textBlack,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Notifications',
              style: AppText.heading2.copyWith(
                color: AppColors.textBlack,
                fontWeight: FontWeight.bold,
              ),
              textScaler: TextScaler.linear(1.0),
            ),
          ),
          Stack(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[200],
                child: const Icon(
                  Icons.person,
                  color: AppColors.primaryRed,
                  size: 24,
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsContent(NotificationsState state) {
    if (state is NotificationsLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is NotificationsLoaded) {
      return _buildNotificationsList();
    } else if (state is NotificationsFailure) {
      return _buildErrorContent(state.message);
    } else {
      return _buildEmptyState();
    }
  }

  Widget _buildNotificationsList() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildSectionHeader('Today'),
        _buildNotificationItem(
          'Setor tunai Mesin Rp. 123.000.000 sukses',
          'Cash deposit Machine Rp. 123,000,000 successful',
        ),
        _buildNotificationItem(
          'Setor tunai Mesin Rp. 5.500.000 masih dalam proses',
          'Cash deposit Machine Rp. 5,500,000 still in process',
        ),
        const SizedBox(height: 24),
        _buildSectionHeader('This Week'),
        _buildNotificationItem(
          'Setor tunai Warung Rp. 500.000 sukses',
          'Cash deposit Shop Rp. 500,000 successful',
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: AppText.heading3.copyWith(
          color: AppColors.textBlack,
          fontWeight: FontWeight.bold,
        ),
        textScaler: TextScaler.linear(1.0),
      ),
    );
  }

  Widget _buildNotificationItem(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
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
              color: AppColors.primaryRed.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              color: AppColors.primaryRed,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppText.bodyMedium.copyWith(
                    color: AppColors.textBlack,
                    fontWeight: FontWeight.w500,
                  ),
                  textScaler: TextScaler.linear(1.0),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppText.bodySmall.copyWith(color: AppColors.textGray),
                  textScaler: TextScaler.linear(1.0),
                ),
              ],
            ),
          ),
        ],
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
