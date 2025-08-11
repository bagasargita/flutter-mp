import 'package:flutter/material.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/constants/app_text.dart';
import 'package:smart_mob/widgets/common/app_top_bar.dart';

class SetorTunaiQRScreen extends StatefulWidget {
  const SetorTunaiQRScreen({super.key});

  @override
  State<SetorTunaiQRScreen> createState() => _SetorTunaiQRScreenState();
}

class _SetorTunaiQRScreenState extends State<SetorTunaiQRScreen> {
  int _remainingSeconds = 59 * 60 + 58; // 59:58 in seconds

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
        _startTimer();
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        body: SafeArea(
          child: Column(
            children: [
              const AppTopBar(title: 'Setor', showBack: true),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildInstructions(),
                      const SizedBox(height: 32),
                      _buildQRCode(),
                      const SizedBox(height: 32),
                      _buildExpiryTimer(),
                      const SizedBox(height: 48),
                      _buildActionButton(),
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

  Widget _buildInstructions() {
    return Column(
      children: [
        Text(
          'QR Code siap digunakan',
          style: AppText.heading3.copyWith(
            color: AppColors.textBlack,
            fontWeight: FontWeight.w600,
          ),
          textScaler: TextScaler.linear(1.0),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Pindai QR Anda pada Mesin',
          style: AppText.bodyMedium.copyWith(color: AppColors.textGray),
          textScaler: TextScaler.linear(1.0),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildQRCode() {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code, size: 120, color: AppColors.primaryRed),
            const SizedBox(height: 16),
            Text(
              'SMARTMobs\nDeposit QR',
              style: AppText.bodyMedium.copyWith(
                color: AppColors.textBlack,
                fontWeight: FontWeight.w600,
              ),
              textScaler: TextScaler.linear(1.0),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpiryTimer() {
    return Column(
      children: [
        Text(
          'QR Code ini akan kadaluarsa dalam',
          style: AppText.bodyMedium.copyWith(color: AppColors.textGray),
          textScaler: TextScaler.linear(1.0),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
          ),
          child: Text(
            _formatTime(_remainingSeconds),
            style: AppText.heading3.copyWith(
              color: Colors.red,
              fontWeight: FontWeight.w700,
            ),
            textScaler: TextScaler.linear(1.0),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          'Selesai',
          style: AppText.bodyLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          textScaler: TextScaler.linear(1.0),
        ),
      ),
    );
  }
}
