import 'package:flutter/material.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/constants/app_text.dart';
import 'package:smart_mob/widgets/common/app_top_bar.dart';

class SetorTunaiLocationScreen extends StatelessWidget {
  const SetorTunaiLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        body: SafeArea(
          child: Column(
            children: [
              const AppTopBar(title: 'Lokasi', showBack: true),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 120,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Lokasi Mesin Setor',
                        style: AppText.heading3.copyWith(
                          color: AppColors.textBlack,
                          fontWeight: FontWeight.w600,
                        ),
                        textScaler: TextScaler.linear(1.0),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Fitur lokasi akan segera hadir',
                        style: AppText.bodyMedium.copyWith(
                          color: AppColors.textGray,
                        ),
                        textScaler: TextScaler.linear(1.0),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
