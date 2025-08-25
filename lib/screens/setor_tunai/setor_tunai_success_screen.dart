import 'package:flutter/material.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/constants/app_text.dart';
import 'package:smart_mob/widgets/common/app_top_bar.dart';
import 'package:smart_mob/widgets/common/watermark_widget.dart';
import 'package:smart_mob/widgets/common/custom_share_sheet.dart';
import 'package:smart_mob/core/services/receipt_service.dart';

class SetorTunaiSuccessScreen extends StatefulWidget {
  final Map<String, dynamic> transactionData;

  const SetorTunaiSuccessScreen({super.key, required this.transactionData});

  @override
  State<SetorTunaiSuccessScreen> createState() =>
      _SetorTunaiSuccessScreenState();
}

class _SetorTunaiSuccessScreenState extends State<SetorTunaiSuccessScreen> {
  bool _showNotification = true;

  @override
  void initState() {
    super.initState();
    _showPushNotification();
  }

  void _showPushNotification() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showNotification = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  const AppTopBar(title: '', showBack: false),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildTransactionReceipt(),
                          const SizedBox(height: 48),
                          _buildActionButtons(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (_showNotification) _buildNotificationBubble(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationBubble() {
    return Positioned(
      top: 100,
      left: 20,
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.attach_money,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Deposit Berhasil!',
                        style: AppText.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textBlack,
                        ),
                        textScaler: TextScaler.linear(1.0),
                      ),
                      Text(
                        'now',
                        style: AppText.bodyMedium.copyWith(
                          color: AppColors.textGray,
                          fontSize: 12,
                        ),
                        textScaler: TextScaler.linear(1.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Deposit berhasil! Dana sudah masuk ke rekening tujuan. Ref: #123456 | 19 Aug 2025, 22:45',
              style: AppText.bodyMedium.copyWith(
                color: AppColors.textGray,
                fontSize: 14,
              ),
              textScaler: TextScaler.linear(1.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionReceipt() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          _buildWatermarkBackground(),
          Column(
            children: [
              _buildReceiptHeader(),
              const SizedBox(height: 32),
              _buildTransactionInfo(),
              const SizedBox(height: 24),
              _buildDenominationBreakdown(),
              const SizedBox(height: 24),
              _buildTotalSection(),
              const SizedBox(height: 24),
              _buildConfirmationMessage(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWatermarkBackground() {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: const WatermarkWidget(
          opacity: 0.08,
          spacing: 120.0,
          rotation: -45.0,
          logoSize: 40.0,
        ),
      ),
    );
  }

  Widget _buildReceiptHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          child: Image.asset(
            'assets/images/LOGO-SVG.png',
            width: 32,
            height: 32,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'MerahPutih',
          style: AppText.heading2.copyWith(
            color: AppColors.textBlack,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
          textScaler: TextScaler.linear(1.0),
        ),
      ],
    );
  }

  Widget _buildTransactionInfo() {
    return Column(
      children: [
        _buildInfoRow('Date', '10/07/2025'),
        const SizedBox(height: 12),
        _buildInfoRow('Time', '21:39:54'),
        const SizedBox(height: 12),
        _buildInfoRow('Lokasi', 'PT Warung Sejahtera\nMaju Makmur'),
        const SizedBox(height: 12),
        _buildInfoRow('Ref', 'KSN001250710211500176'),
        const SizedBox(height: 12),
        _buildInfoRow('TID', 'KSN001'),
        const SizedBox(height: 12),
        _buildInfoRow('Nama', 'Wahid'),
        const SizedBox(height: 12),
        _buildInfoRow('Trx', 'Setoran'),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: AppText.bodyMedium.copyWith(
              color: AppColors.textBlack,
              fontWeight: FontWeight.w600,
            ),
            textScaler: TextScaler.linear(1.0),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            style: AppText.bodyMedium.copyWith(
              color: AppColors.textBlack,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
            textScaler: TextScaler.linear(1.0),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }

  Widget _buildDenominationBreakdown() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 1,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.grey[400]!,
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                'Denom',
                style: AppText.bodyMedium.copyWith(
                  color: AppColors.textBlack,
                  fontWeight: FontWeight.w700,
                ),
                textScaler: TextScaler.linear(1.0),
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'Lembar',
                style: AppText.bodyMedium.copyWith(
                  color: AppColors.textBlack,
                  fontWeight: FontWeight.w700,
                ),
                textScaler: TextScaler.linear(1.0),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                'Total',
                style: AppText.bodyMedium.copyWith(
                  color: AppColors.textBlack,
                  fontWeight: FontWeight.w700,
                ),
                textScaler: TextScaler.linear(1.0),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildDenomRow('1.000', '87', '87.000'),
        _buildDenomRow('2.000', '533', '1.066.000'),
        _buildDenomRow('5.000', '96', '480.000'),
        _buildDenomRow('10.000', '64', '640.000'),
        _buildDenomRow('20.000', '53', '1.060.000'),
        _buildDenomRow('50.000', '331', '16.550.000'),
        _buildDenomRow('100.000', '367', '36.700.000'),
      ],
    );
  }

  Widget _buildDenomRow(String denom, String quantity, String total) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              denom,
              style: AppText.bodyMedium.copyWith(
                color: AppColors.textBlack,
                fontWeight: FontWeight.w500,
              ),
              textScaler: TextScaler.linear(1.0),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              quantity,
              style: AppText.bodyMedium.copyWith(
                color: AppColors.textBlack,
                fontWeight: FontWeight.w500,
              ),
              textScaler: TextScaler.linear(1.0),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              total,
              style: AppText.bodyMedium.copyWith(
                color: AppColors.textBlack,
                fontWeight: FontWeight.w600,
              ),
              textScaler: TextScaler.linear(1.0),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSection() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 1,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.grey[400]!,
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                'Total:',
                style: AppText.bodyLarge.copyWith(
                  color: AppColors.textBlack,
                  fontWeight: FontWeight.w700,
                ),
                textScaler: TextScaler.linear(1.0),
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '1.531',
                style: AppText.bodyLarge.copyWith(
                  color: AppColors.textBlack,
                  fontWeight: FontWeight.w700,
                ),
                textScaler: TextScaler.linear(1.0),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                '56.583.000',
                style: AppText.bodyLarge.copyWith(
                  color: AppColors.textBlack,
                  fontWeight: FontWeight.w700,
                ),
                textScaler: TextScaler.linear(1.0),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConfirmationMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Text(
            'Struk transaksi ini digunakan',
            style: AppText.bodyMedium.copyWith(
              color: AppColors.textBlack,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
            textScaler: TextScaler.linear(1.0),
            textAlign: TextAlign.center,
          ),
          Text(
            'sebagai tanda bukti transaksi',
            style: AppText.bodyMedium.copyWith(
              color: AppColors.textBlack,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
            textScaler: TextScaler.linear(1.0),
            textAlign: TextAlign.center,
          ),
          Text(
            'yang sah',
            style: AppText.bodyMedium.copyWith(
              color: AppColors.textBlack,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
            textScaler: TextScaler.linear(1.0),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _downloadReceipt,
                  icon: const Icon(Icons.download, size: 12),
                  label: Text(
                    'Unduh Bukti Setor',
                    style: AppText.bodyLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    textScaler: TextScaler.linear(1.0),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _shareReceipt,
                  onLongPress: _shareReceipt,
                  icon: const Icon(Icons.share, size: 12),
                  label: Text(
                    'Bagikan',
                    style: AppText.bodyLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    textScaler: TextScaler.linear(1.0),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _downloadReceipt() async {
    try {
      final denominations = [
        {'denom': '1.000', 'quantity': '87', 'total': '87.000'},
        {'denom': '2.000', 'quantity': '533', 'total': '1.066.000'},
        {'denom': '5.000', 'quantity': '96', 'total': '480.000'},
        {'denom': '10.000', 'quantity': '64', 'total': '640.000'},
        {'denom': '20.000', 'quantity': '53', 'total': '1.060.000'},
        {'denom': '50.000', 'quantity': '331', 'total': '16.550.000'},
        {'denom': '100.000', 'quantity': '367', 'total': '36.700.000'},
      ];

      final pdfFile = await ReceiptService.generateReceiptPDF(
        reference: 'KSN001250710211500176',
        total: 'Rp 56.583.000',
        date: '10/07/2025',
        time: '21:39:54',
        location: 'PT Warung Sejahtera Maju Makmur',
        name: 'Wahid',
        transactionType: 'Setoran',
        denominations: denominations,
      );

      if (pdfFile != null && await pdfFile.exists()) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Receipt PDF generated successfully!'),
              backgroundColor: AppColors.successGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              action: SnackBarAction(
                label: 'Share',
                textColor: Colors.white,
                onPressed: () => _shareReceipt(),
              ),
            ),
          );
        }
      } else {
        throw Exception('Failed to generate PDF');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengunduh bukti setor: ${e.toString()}'),
            backgroundColor: AppColors.errorRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  Future<void> _shareReceipt() async {
    try {
      final denominations = [
        {'denom': '1.000', 'quantity': '87', 'total': '87.000'},
        {'denom': '2.000', 'quantity': '533', 'total': '1.066.000'},
        {'denom': '5.000', 'quantity': '96', 'total': '480.000'},
        {'denom': '10.000', 'quantity': '64', 'total': '640.000'},
        {'denom': '20.000', 'quantity': '53', 'total': '1.060.000'},
        {'denom': '50.000', 'quantity': '331', 'total': '16.550.000'},
        {'denom': '100.000', 'quantity': '367', 'total': '36.700.000'},
      ];

      await ReceiptService.shareReceiptSimple(
        reference: 'KSN001250710211500176',
        total: 'Rp 56.583.000',
        date: '10/07/2025',
        time: '21:39:54',
        location: 'PT Warung Sejahtera Maju Makmur',
        name: 'Wahid',
        transactionType: 'Setoran',
        denominations: denominations,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Receipt shared successfully!'),
            backgroundColor: AppColors.successGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share receipt: ${e.toString()}'),
            backgroundColor: AppColors.errorRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  void _showCustomShareSheet() {
    final receiptData = {
      'reference': 'KSN001250710211500176',
      'total': 'Rp 56.583.000',
      'date': '10/07/2025',
      'time': '21:39:54',
      'location': 'PT Warung Sejahtera Maju Makmur',
      'name': 'Wahid',
      'transactionType': 'Setoran',
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomShareSheet(
        onClose: () => Navigator.pop(context),
        onNativeShare: _shareReceipt,
        receiptData: receiptData,
      ),
    );
  }
}
