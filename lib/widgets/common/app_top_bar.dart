import 'package:flutter/material.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/constants/app_text.dart';

class AppTopBar extends StatelessWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final bool showNotifications;
  final VoidCallback? onNotificationsTap;
  final Widget? trailing;
  final Widget? leading;

  const AppTopBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.onBack,
    this.showNotifications = true,
    this.onNotificationsTap,
    this.trailing,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Row(
        children: [
          if (showBack)
            GestureDetector(
              onTap: onBack ?? () => Navigator.pop(context),
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
            )
          else if (leading != null)
            leading!
          else
            const SizedBox(width: 36),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: AppText.heading2.copyWith(
                color: AppColors.textBlack,
                fontWeight: FontWeight.bold,
              ),
              textScaler: TextScaler.linear(1.0),
            ),
          ),
          if (trailing != null) trailing! else _buildNotifications(context),
        ],
      ),
    );
  }

  Widget _buildNotifications(BuildContext context) {
    if (!showNotifications) {
      return const SizedBox.shrink();
    }
    return GestureDetector(
      onTap:
          onNotificationsTap ??
          () => Navigator.pushNamed(context, '/notifications'),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications,
              color: AppColors.textBlack,
              size: 20,
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.primaryRed,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
