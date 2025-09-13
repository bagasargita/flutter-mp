import 'package:flutter/material.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/constants/app_text.dart';
import 'package:smart_mob/widgets/common/app_top_bar.dart';
import 'package:qr/qr.dart';
import 'dart:convert';
import 'package:smart_mob/core/di/service_locator.dart';
import 'package:smart_mob/features/auth/domain/entities/user.dart';
import 'package:smart_mob/features/setor_tunai/domain/entities/beneficiary_account.dart';

class SetorTunaiQRScreen extends StatefulWidget {
  const SetorTunaiQRScreen({super.key});

  @override
  State<SetorTunaiQRScreen> createState() => _SetorTunaiQRScreenState();
}

class _SetorTunaiQRScreenState extends State<SetorTunaiQRScreen> {
  int _remainingSeconds = 3 * 60; // 3 minutes
  bool _isProcessing = false;
  bool _isSuccess = false;
  QrImage? _qrImage;
  String? _selectedBeneficiaryAccountId;
  List<BeneficiaryAccount> _beneficiaryAccounts = [];
  bool _isLoadingAccounts = false;

  @override
  void initState() {
    super.initState();
    _loadBeneficiaryAccounts();
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
    print('SetorTunaiQRScreen: _generateQr called');
    print(
      'SetorTunaiQRScreen: Selected beneficiary account ID: $_selectedBeneficiaryAccountId',
    );

    if (_selectedBeneficiaryAccountId == null) {
      print('SetorTunaiQRScreen: No beneficiary account selected');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih rekening tujuan terlebih dahulu'),
          backgroundColor: AppColors.primaryRed,
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final api = ServiceLocator().apiClient;
      final payload = {'beneficiary_account_id': _selectedBeneficiaryAccountId};
      print('SetorTunaiQRScreen: Creating QR with payload: $payload');

      final response = await api.createQr(payload: payload);
      print('SetorTunaiQRScreen: QR creation response: ${response.statusCode}');
      print('SetorTunaiQRScreen: QR creation data: ${response.data}');

      final data =
          response.data ??
          {'beneficiary_account_id': _selectedBeneficiaryAccountId};
      final jsonString = jsonEncode(data);
      print('SetorTunaiQRScreen: QR data string: $jsonString');

      final code = QrCode(4, QrErrorCorrectLevel.M)..addData(jsonString);
      setState(() {
        _qrImage = QrImage(code);
        _isProcessing = false;
      });
      print('SetorTunaiQRScreen: QR generated successfully');
      _startTimer();
    } catch (e) {
      print('SetorTunaiQRScreen: Error generating QR: $e');
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

  Future<void> _loadBeneficiaryAccounts() async {
    print('SetorTunaiQRScreen: _loadBeneficiaryAccounts called');
    try {
      final authRepo = ServiceLocator().authRepository;
      final result = await authRepo.getCurrentUser();
      result.fold(
        (_) {
          print('SetorTunaiQRScreen: Failed to get current user');
        },
        (User? user) {
          print(
            'SetorTunaiQRScreen: Current user: ${user?.email}, branchId: ${user?.branchId}',
          );
          if (user?.branchId != null) {
            _fetchBeneficiaryAccounts(user!.branchId!);
          } else {
            print('SetorTunaiQRScreen: User branchId is null');
          }
        },
      );
    } catch (e) {
      print('SetorTunaiQRScreen: Error in _loadBeneficiaryAccounts: $e');
    }
  }

  Future<void> _fetchBeneficiaryAccounts(String branchId) async {
    print(
      'SetorTunaiQRScreen: _fetchBeneficiaryAccounts called with branchId: $branchId',
    );
    setState(() {
      _isLoadingAccounts = true;
    });

    try {
      final beneficiaryService = ServiceLocator().beneficiaryAccountService;
      print(
        'SetorTunaiQRScreen: Calling beneficiaryService.getBeneficiaryAccounts',
      );
      final response = await beneficiaryService.getBeneficiaryAccounts(
        branchId: branchId,
      );

      print('SetorTunaiQRScreen: Response received: ${response.statusCode}');
      print('SetorTunaiQRScreen: Response data: ${response.data}');

      if (response.data != null && response.data!['data'] != null) {
        final List<dynamic> accountsData =
            response.data!['data'] as List<dynamic>;
        print(
          'SetorTunaiQRScreen: Found ${accountsData.length} beneficiary accounts',
        );

        final accounts = accountsData
            .map(
              (json) =>
                  BeneficiaryAccount.fromJson(json as Map<String, dynamic>),
            )
            .toList();

        print(
          'SetorTunaiQRScreen: Parsed accounts: ${accounts.map((a) => a.toString()).toList()}',
        );

        setState(() {
          _beneficiaryAccounts = accounts;
          if (accounts.isNotEmpty) {
            _selectedBeneficiaryAccountId = accounts.first.id;
            print(
              'SetorTunaiQRScreen: Selected first account: ${accounts.first.id}',
            );
          }
        });
      } else {
        print('SetorTunaiQRScreen: No data found in response or data is null');
      }
    } catch (e) {
      print('SetorTunaiQRScreen: Error in _fetchBeneficiaryAccounts: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat daftar rekening: ${e.toString()}'),
          backgroundColor: AppColors.primaryRed,
        ),
      );
    } finally {
      setState(() {
        _isLoadingAccounts = false;
      });
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
                      if (_qrImage == null) ...[
                        const SizedBox(height: 24),
                        _buildBeneficiaryAccountDropdown(),
                        const SizedBox(height: 16),
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
              ? 'Pilih rekening tujuan dan Generate QR untuk memulai setoran'
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
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code, size: 80, color: AppColors.primaryRed),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 180,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : _generateQr,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _isProcessing ? 'Memproses...' : 'Generate QR',
                        style: AppText.kaiseiRegular.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        textScaler: TextScaler.linear(1.0),
                      ),
                    ),
                  ),
                ],
              )
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

  Widget _buildBeneficiaryAccountDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih Rekening Tujuan',
          style: AppText.kaiseiRegular.copyWith(
            color: AppColors.textBlack,
            fontWeight: FontWeight.w600,
          ),
          textScaler: TextScaler.linear(1.0),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: _isLoadingAccounts
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryRed,
                    ),
                  ),
                )
              : DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedBeneficiaryAccountId,
                    hint: Text(
                      'Pilih rekening tujuan',
                      style: AppText.kaiseiRegular.copyWith(
                        color: Colors.grey[600],
                      ),
                      textScaler: TextScaler.linear(1.0),
                    ),
                    isExpanded: true,
                    items: _beneficiaryAccounts.map((
                      BeneficiaryAccount account,
                    ) {
                      return DropdownMenuItem<String>(
                        value: account.id,
                        child: Text(
                          account.toString(),
                          style: AppText.kaiseiRegular.copyWith(
                            color: AppColors.textBlack,
                          ),
                          textScaler: TextScaler.linear(1.0),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedBeneficiaryAccountId = newValue;
                      });
                    },
                  ),
                ),
        ),
      ],
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
