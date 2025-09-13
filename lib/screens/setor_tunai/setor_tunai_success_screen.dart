import 'package:flutter/material.dart';
import 'package:merah_putih/constants/app_colors.dart';
import 'package:merah_putih/constants/app_text.dart';
import 'package:merah_putih/widgets/common/app_top_bar.dart';
import 'package:merah_putih/widgets/common/watermark_widget.dart';
import 'package:merah_putih/widgets/common/custom_share_sheet.dart';
import 'package:merah_putih/core/services/receipt_service.dart';

class SetorTunaiSuccessScreen extends StatefulWidget {
  final Map<String, dynamic> transactionData;

  const SetorTunaiSuccessScreen({super.key, required this.transactionData});

  @override
  State<SetorTunaiSuccessScreen> createState() =>
      _SetorTunaiSuccessScreenState();
}

class _SetorTunaiSuccessScreenState extends State<SetorTunaiSuccessScreen> {
  bool _showNotification = true;

  String _getTransactionAmount() {
    final depositAmount = widget.transactionData['depositAmount'];
    if (depositAmount != null) {
      return depositAmount.toString();
    }

    final amount = widget.transactionData['amount']?.toString() ?? '0';
    return amount.replaceAll('Rp. ', '').replaceAll('.', '');
  }

  String _getTransactionDate() {
    final transactionDate = widget.transactionData['transactionDate']
        ?.toString();
    if (transactionDate != null && transactionDate.isNotEmpty) {
      try {
        final date = DateTime.parse(transactionDate);
        return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      } catch (e) {
        return transactionDate;
      }
    }

    final dateString = widget.transactionData['date']?.toString() ?? '';
    if (dateString.isNotEmpty) {
      final parts = dateString.split(' ');
      return parts.isNotEmpty ? parts[0] : 'N/A';
    }
    return 'N/A';
  }

  String _getTransactionTime() {
    final transactionTime = widget.transactionData['transactionTime']
        ?.toString();
    if (transactionTime != null && transactionTime.isNotEmpty) {
      return transactionTime;
    }

    final dateString = widget.transactionData['date']?.toString() ?? '';
    if (dateString.isNotEmpty) {
      final parts = dateString.split(' ');
      if (parts.length > 1) {
        return parts.sublist(1).join(' ');
      }
    }
    return 'N/A';
  }

  String _getTransactionLocation() {
    final location = widget.transactionData['location']?.toString();
    if (location != null && location.isNotEmpty) {
      return location;
    }

    final company = widget.transactionData['company']?.toString();
    if (company != null && company.isNotEmpty) {
      return company;
    }

    final accountName = widget.transactionData['accountName']?.toString();
    if (accountName != null && accountName.isNotEmpty) {
      return accountName;
    }

    return 'N/A';
  }

  String _getTransactionRef() {
    return widget.transactionData['transactionNumber']?.toString() ?? 'N/A';
  }

  String _getTransactionTid() {
    return widget.transactionData['machine']?.toString() ?? 'N/A';
  }

  String _getTransactionName() {
    return widget.transactionData['user']?.toString() ?? 'N/A';
  }

  String _getTransactionType() {
    return widget.transactionData['type']?.toString() ?? 'Setoran';
  }

  List<Map<String, String>> _getDenominations() {
    final denominations =
        widget.transactionData['denominations'] as List<dynamic>?;
    if (denominations == null) return [];

    return denominations.map<Map<String, String>>((item) {
      if (item is Map<String, dynamic>) {
        final amount = item['amount'] ?? 0;
        final quantity = item['quantity'] ?? 0;
        final denomination = item['denomination'] ?? 0;

        return {
          'denom': denomination.toString(),
          'quantity': quantity.toString(),
          'total': amount.toString(),
        };
      }
      return {'denom': '0', 'quantity': '0', 'total': '0'};
    }).toList();
  }

  String _formatDenomination(String denom) {
    final value = int.tryParse(denom) ?? 0;
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}.000';
    }
    return value.toString();
  }

  String _formatAmount(String amount) {
    final value = int.tryParse(amount) ?? 0;
    final s = value.toString();
    final buf = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buf.write(s[i]);
      count++;
      if (count == 3 && i != 0) {
        buf.write('.');
        count = 0;
      }
    }
    final reversed = buf.toString().split('').reversed.join();
    return reversed;
  }

  @override
  void initState() {
    super.initState();
    _logTransactionData();
    _showPushNotification();
  }

  void _logTransactionData() {
    print('=== SUCCESS SCREEN RECEIVED DATA ===');
    print('Transaction data received:');
    print('Raw data: ${widget.transactionData}');
    print('--- Parsed Data ---');
    print('Amount: ${_getTransactionAmount()}');
    print('Date: ${_getTransactionDate()}');
    print('Time: ${_getTransactionTime()}');
    print('Location: ${_getTransactionLocation()}');
    print('Reference: ${_getTransactionRef()}');
    print('TID: ${_getTransactionTid()}');
    print('Name: ${_getTransactionName()}');
    print('Type: ${_getTransactionType()}');
    print('Denominations: ${_getDenominations()}');
    print('--- Available Keys ---');
    print('Keys in transactionData: ${widget.transactionData.keys.toList()}');
    print('===============================');
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
                  const AppTopBar(title: '', showBack: true),
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
                        style: AppText.kaiseiRegular.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textBlack,
                        ),
                        textScaler: TextScaler.linear(1.0),
                      ),
                      Text(
                        'now',
                        style: AppText.kaiseiRegular.copyWith(
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
              style: AppText.kaiseiRegular.copyWith(
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
          style: AppText.kaiseiBold.copyWith(
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
        _buildInfoRow('Date', _getTransactionDate()),
        const SizedBox(height: 12),
        _buildInfoRow('Time', _getTransactionTime()),
        const SizedBox(height: 12),
        _buildInfoRow('Lokasi', _getTransactionLocation()),
        const SizedBox(height: 12),
        _buildInfoRow('Ref', _getTransactionRef()),
        const SizedBox(height: 12),
        _buildInfoRow('TID', _getTransactionTid()),
        const SizedBox(height: 12),
        _buildInfoRow('Nama', _getTransactionName()),
        const SizedBox(height: 12),
        _buildInfoRow('Trx', _getTransactionType()),
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
            style: AppText.kaiseiRegular.copyWith(
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
            style: AppText.kaiseiRegular.copyWith(
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
                style: AppText.kaiseiRegular.copyWith(
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
                style: AppText.kaiseiRegular.copyWith(
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
                style: AppText.kaiseiRegular.copyWith(
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
        ..._getDenominations().map(
          (denom) => _buildDenomRow(
            _formatDenomination(denom['denom']!),
            denom['quantity']!,
            _formatAmount(denom['total']!),
          ),
        ),
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
              style: AppText.kaiseiRegular.copyWith(
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
              style: AppText.kaiseiRegular.copyWith(
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
              style: AppText.kaiseiRegular.copyWith(
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
                style: AppText.kaiseiRegular.copyWith(
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
                style: AppText.kaiseiRegular.copyWith(
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
                _getTransactionAmount(),
                style: AppText.kaiseiRegular.copyWith(
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
            style: AppText.kaiseiRegular.copyWith(
              color: AppColors.textBlack,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
            textScaler: TextScaler.linear(1.0),
            textAlign: TextAlign.center,
          ),
          Text(
            'sebagai tanda bukti transaksi',
            style: AppText.kaiseiRegular.copyWith(
              color: AppColors.textBlack,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
            textScaler: TextScaler.linear(1.0),
            textAlign: TextAlign.center,
          ),
          Text(
            'yang sah',
            style: AppText.kaiseiRegular.copyWith(
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
                    style: AppText.kaiseiRegular.copyWith(
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
                    style: AppText.kaiseiRegular.copyWith(
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
      final denominations = _getDenominations();

      final pdfFile = await ReceiptService.generateReceiptPDF(
        reference: _getTransactionRef(),
        total: 'Rp ${_getTransactionAmount()}',
        date: _getTransactionDate(),
        time: _getTransactionTime(),
        location: _getTransactionLocation(),
        name: _getTransactionName(),
        transactionType: _getTransactionType(),
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
      final denominations = _getDenominations();

      await ReceiptService.shareReceiptSimple(
        reference: _getTransactionRef(),
        total: 'Rp ${_getTransactionAmount()}',
        date: _getTransactionDate(),
        time: _getTransactionTime(),
        location: _getTransactionLocation(),
        name: _getTransactionName(),
        transactionType: _getTransactionType(),
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
}
