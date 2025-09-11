import 'package:flutter/material.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/constants/app_text.dart';
import 'package:smart_mob/widgets/common/app_top_bar.dart';
// removed unused import
import 'package:qr/qr.dart';
import 'dart:convert';
import 'package:smart_mob/core/di/service_locator.dart';
import 'package:smart_mob/features/auth/domain/entities/user.dart';

class SetorTunaiQRScreen extends StatefulWidget {
  const SetorTunaiQRScreen({super.key});

  @override
  State<SetorTunaiQRScreen> createState() => _SetorTunaiQRScreenState();
}

class _SetorTunaiQRScreenState extends State<SetorTunaiQRScreen> {
  int _remainingSeconds = 3 * 60; // 3 minutes
  bool _isProcessing = false;
  bool _isSuccess = false;
  final TextEditingController _qrDataController = TextEditingController();
  QrImage? _qrImage;
  String? _loggedInEmail;

  @override
  void initState() {
    super.initState();
    _prefillEmailFromLogin();
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

  // removed unused method

  void _generateQr() async {
    final email = (_loggedInEmail ?? _qrDataController.text).trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email tidak boleh kosong'),
          backgroundColor: AppColors.primaryRed,
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      // final api = ServiceLocator().apiClient;
      // final response = await api.createQr(payload: {'email': email});
      // final data = response.data ?? {'email': email};
      // final jsonString = jsonEncode(data);
      final code = QrCode(4, QrErrorCorrectLevel.M)..addData(email);
      setState(() {
        _qrImage = QrImage(code);
        _isProcessing = false;
      });
      _startTimer();
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuat QR: ${e.toString()}'),
          backgroundColor: AppColors.primaryRed,
        ),
      );
    }
  }

  Future<void> _prefillEmailFromLogin() async {
    try {
      final authRepo = ServiceLocator().authRepository;
      final result = await authRepo.getCurrentUser();
      result.fold((_) {}, (User? user) {
        final u = user;
        final email = u?.email;
        if (email != null && email.isNotEmpty) {
          _loggedInEmail = email;
          _qrDataController.text = email;
          setState(() {});
        }
      });
    } catch (_) {}
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
                      if (_qrImage == null) ...[
                        const SizedBox(height: 24),
                        _buildGenerateButton(),
                      ],
                      const SizedBox(height: 24),
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
          (_qrImage == null
              ? 'Silakan Generate QR untuk memulai setoran'
              : 'QR Code siap digunakan'),
          style: AppText.kaiseiBold.copyWith(
            color: AppColors.textBlack,
            fontWeight: FontWeight.w600,
          ),
          textScaler: TextScaler.linear(1.0),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Pindai QR Anda pada Mesin',
          style: AppText.kaiseiRegular.copyWith(color: AppColors.textGray),
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
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: _qrImage == null
            ? Icon(Icons.qr_code, size: 150, color: AppColors.primaryRed)
            : CustomPaint(
                size: const Size.square(220),
                painter: _QrPainter(_qrImage!),
              ),
      ),
    );
  }

  Widget _buildExpiryTimer() {
    return Column(
      children: [
        Text(
          'QR Code ini akan kadaluarsa dalam',
          style: AppText.kaiseiRegular.copyWith(color: AppColors.textGray),
          textScaler: TextScaler.linear(1.0),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.withOpacity(0.3)),
          ),
          child: Text(
            _formatTime(_remainingSeconds),
            style: AppText.kaiseiBold.copyWith(
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
          style: AppText.kaiseiRegular.copyWith(
            color: _isSuccess ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
          textScaler: TextScaler.linear(1.0),
        ),
      ),
    );
  }

  Widget _buildInputAndButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _qrDataController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email untuk QR',
            border: OutlineInputBorder(),
          ),
          readOnly: _loggedInEmail != null,
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _isProcessing ? null : _generateQr,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              _isProcessing ? 'Memproses...' : 'Generate QR',
              style: AppText.kaiseiRegular.copyWith(color: Colors.white),
              textScaler: TextScaler.linear(1.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _generateQr,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          _isProcessing ? 'Memproses...' : 'Generate QR',
          style: AppText.kaiseiRegular.copyWith(color: Colors.white),
          textScaler: TextScaler.linear(1.0),
        ),
      ),
    );
  }
}

class _QrPainter extends CustomPainter {
  final QrImage qrImage;

  _QrPainter(this.qrImage);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;
    final moduleCount = qrImage.moduleCount;
    final pixelSize = size.width / moduleCount;
    for (var x = 0; x < moduleCount; x++) {
      for (var y = 0; y < moduleCount; y++) {
        if (qrImage.isDark(y, x)) {
          final rect = Rect.fromLTWH(
            x * pixelSize,
            y * pixelSize,
            pixelSize,
            pixelSize,
          );
          canvas.drawRect(rect, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _QrPainter oldDelegate) {
    return oldDelegate.qrImage != qrImage;
  }
}
