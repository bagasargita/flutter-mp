import 'package:flutter/material.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/constants/app_text.dart';

class OutstandingTransactionCard extends StatefulWidget {
  const OutstandingTransactionCard({super.key});

  @override
  State<OutstandingTransactionCard> createState() => _OutstandingTransactionCardState();
}

class _OutstandingTransactionCardState extends State<OutstandingTransactionCard> {
  int _remainingSeconds = 34 * 60 + 55; // 34:55 in seconds

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
    if (_remainingSeconds <= 0) {
      return const SizedBox.shrink();
    }

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Outstanding',
                style: AppText.bodyMedium.copyWith(
                  color: AppColors.textBlack,
                  fontWeight: FontWeight.w600,
                ),
                textScaler: TextScaler.linear(1.0),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mesin K5001',
                      style: AppText.bodyMedium.copyWith(
                        color: AppColors.textBlack,
                        fontWeight: FontWeight.w600,
                      ),
                      textScaler: TextScaler.linear(1.0),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Toko Mamang',
                      style: AppText.bodySmall.copyWith(
                        color: AppColors.textGray,
                      ),
                      textScaler: TextScaler.linear(1.0),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'JL. SMP 87 Pondok Pinang',
                      style: AppText.bodySmall.copyWith(
                        color: AppColors.textGray,
                      ),
                      textScaler: TextScaler.linear(1.0),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: Text(
                  _formatTime(_remainingSeconds),
                  style: AppText.bodyMedium.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                  textScaler: TextScaler.linear(1.0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
