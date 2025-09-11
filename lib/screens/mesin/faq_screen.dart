import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'FAQ',
          style: AppText.kaiseiRegular.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.help_outline, size: 64, color: AppColors.primaryRed),
            SizedBox(height: 16),
            Text(
              'FAQ',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Halaman FAQ akan segera hadir',
              style: TextStyle(fontSize: 16, color: AppColors.textGray),
            ),
          ],
        ),
      ),
    );
  }
}
