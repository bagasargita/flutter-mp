import 'package:flutter/material.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/constants/app_text.dart';

class OutstandingTransactionCard extends StatefulWidget {
  final Map<String, dynamic> machine;
  final VoidCallback? onClear;
  final VoidCallback? onStartDeposit;

  const OutstandingTransactionCard({
    super.key,
    required this.machine,
    this.onClear,
    this.onStartDeposit,
  });

  @override
  State<OutstandingTransactionCard> createState() =>
      _OutstandingTransactionCardState();
}

class _OutstandingTransactionCardState
    extends State<OutstandingTransactionCard> {
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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
              const Spacer(),
              // Clear button
              if (widget.onClear != null)
                GestureDetector(
                  onTap: widget.onClear,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, size: 16, color: Colors.grey[600]),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Container(width: double.infinity, height: 1, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.machine['name'] ?? 'Mesin KS001',
                      style: AppText.bodyMedium.copyWith(
                        color: AppColors.textBlack,
                        fontWeight: FontWeight.w600,
                      ),
                      textScaler: TextScaler.linear(1.0),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.machine['location'] ?? 'Toko Mamang',
                      style: AppText.bodySmall.copyWith(
                        color: AppColors.textGray,
                      ),
                      textScaler: TextScaler.linear(1.0),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.machine['address'] ?? 'JL. SMP 87 Pondok Pinang',
                      style: AppText.bodySmall.copyWith(
                        color: AppColors.textGray,
                      ),
                      textScaler: TextScaler.linear(1.0),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
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
                  const SizedBox(height: 8),
                  // Mulai Setor button
                  if (widget.onStartDeposit != null)
                    SizedBox(
                      width: 100,
                      height: 32,
                      child: ElevatedButton(
                        onPressed: widget.onStartDeposit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Mulai Setor',
                          style: AppText.bodySmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
