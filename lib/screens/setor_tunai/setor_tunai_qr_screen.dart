import 'package:flutter/material.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/constants/app_text.dart';
import 'package:smart_mob/widgets/common/app_top_bar.dart';
import 'package:smart_mob/screens/setor_tunai/setor_tunai_success_screen.dart';

class SetorTunaiQRScreen extends StatefulWidget {
  const SetorTunaiQRScreen({super.key});

  @override
  State<SetorTunaiQRScreen> createState() => _SetorTunaiQRScreenState();
}

class _SetorTunaiQRScreenState extends State<SetorTunaiQRScreen> {
  int _remainingSeconds = 59 * 60 + 58; // 59:58 in seconds
  bool _isProcessing = false;
  bool _isSuccess = false;

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

  void _simulateDeposit() async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate processing time
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isProcessing = false;
      _isSuccess = true;
    });

    // Navigate to success screen after a short delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SetorTunaiSuccessScreen(
            transactionData: {
              'name': 'Mesin KS001',
              'location': 'Toko Mamang',
              'address': 'JL. SMP 87 Pondok Pinang',
              'maxAmount': 'Rp. 5.000.000,-',
              'distance': '1.0 km',
            },
          ),
        ),
      );
    }
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
    return GestureDetector(
      onTap: _isProcessing ? null : _simulateDeposit,
      child: Container(
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
              if (_isProcessing)
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryRed,
                  ),
                )
              else if (_isSuccess)
                const Icon(Icons.check_circle, size: 120, color: Colors.green)
              else
                Icon(Icons.qr_code, size: 120, color: AppColors.primaryRed),
              const SizedBox(height: 16),
              Text(
                _isProcessing
                    ? 'Memproses Deposit...'
                    : _isSuccess
                    ? 'Deposit Berhasil!'
                    : 'SMARTMobs\nDeposit QR\n\nTap untuk simulasi',
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
    if (_isProcessing) {
      return const SizedBox.shrink(); // Hide button while processing
    }

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isSuccess
            ? () => Navigator.popUntil(context, (route) => route.isFirst)
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isSuccess ? AppColors.primaryRed : Colors.grey[300],
          foregroundColor: _isSuccess ? Colors.white : Colors.grey[600],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          _isSuccess ? 'Selesai' : 'Tunggu...',
          style: AppText.bodyLarge.copyWith(
            color: _isSuccess ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
          textScaler: TextScaler.linear(1.0),
        ),
      ),
    );
  }
}
