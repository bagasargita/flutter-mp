import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [_buildContactSection()]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
              size: 24,
              color: AppColors.textBlack,
            ),
          ),
          const Expanded(
            child: Text(
              'Kontak',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
              textAlign: TextAlign.center,
              textScaler: TextScaler.linear(1.0),
            ),
          ),
          Stack(
            children: [
              const Icon(
                Icons.notifications,
                size: 24,
                color: AppColors.textBlack,
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
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hubungi Kami',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
          textScaler: TextScaler.linear(1.0),
        ),
        const SizedBox(height: 24),
        _buildContactItem(
          icon: Icons.phone,
          text: 'WA +62 21 123 123',
          onTap: () {
            // Handle WhatsApp contact
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'Email',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
          textScaler: TextScaler.linear(1.0),
        ),
        const SizedBox(height: 16),
        _buildContactItem(
          icon: Icons.email,
          text: 'support@merahputih-id.com',
          onTap: () {
            // Handle email contact
          },
        ),
      ],
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryRed, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textBlack,
                ),
                textScaler: TextScaler.linear(1.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
