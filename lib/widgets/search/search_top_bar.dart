import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class SearchTopBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final Widget? trailing;

  const SearchTopBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          if (onBackPressed != null)
            GestureDetector(
              onTap: onBackPressed,
              child: const Icon(
                Icons.arrow_back,
                size: 24,
                color: AppColors.textBlack,
              ),
            ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
              textAlign: TextAlign.center,
              textScaler: const TextScaler.linear(1.0),
            ),
          ),
          trailing ?? _buildDefaultTrailing(),
        ],
      ),
    );
  }

  Widget _buildDefaultTrailing() {
    return Stack(
      children: [
        const Icon(Icons.notifications, size: 24, color: AppColors.textBlack),
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
    );
  }
}
