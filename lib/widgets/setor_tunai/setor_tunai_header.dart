import 'package:flutter/material.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/constants/app_text.dart';

class SetorTunaiHeader extends StatelessWidget {
  const SetorTunaiHeader({super.key});

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
          CircleAvatar(
            radius: 20,
            backgroundImage: const AssetImage('assets/images/profile.png'),
            backgroundColor: Colors.grey[200],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'SMARTMobs',
              style: AppText.heading2.copyWith(
                color: AppColors.textBlack,
                fontWeight: FontWeight.bold,
              ),
              textScaler: TextScaler.linear(1.0),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/notifications');
            },
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
          ),
        ],
      ),
    );
  }
}
