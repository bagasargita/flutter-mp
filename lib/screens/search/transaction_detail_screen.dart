import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/common/watermark_widget.dart';

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        body: SafeArea(
          child: Column(
            children: [
              const AppTopBar(title: 'MerahPutih', showBack: true),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildTransactionDetails(),
                      const SizedBox(height: 24),
                      _buildDenominationTable(),
                      const SizedBox(height: 24),
                      _buildTotals(),
                      const SizedBox(height: 24),
                      _buildStatusSection(),
                      const SizedBox(height: 24),
                      _buildDisclaimer(),
                      const SizedBox(height: 40),
                      _buildActionButtons(),
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

  Widget _buildTransactionDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: const WatermarkWidget(
                opacity: 0.06,
                spacing: 120.0,
                rotation: -45.0,
                logoSize: 35.0,
              ),
            ),
          ),
          Column(
            children: [
              _buildDetailRow('Date', '10/07/2025'),
              _buildDetailRow('Time', '21:36:54'),
              _buildDetailRow('Location', 'PT Warung Sejahtera Maju Makmur'),
              _buildDetailRow('Ref', 'KSM001250710211500178'),
              _buildDetailRow('TID', 'KSM001'),
              _buildDetailRow('Name', 'Wahid'),
              _buildDetailRow('Trx', 'Setoran'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textGray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textBlack,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDenominationTable() {
    final denominations = [
      {'denom': '1.000', 'quantity': '87', 'total': '87.000'},
      {'denom': '2.000', 'quantity': '533', 'total': '1.066.000'},
      {'denom': '5.000', 'quantity': '96', 'total': '480.000'},
      {'denom': '10.000', 'quantity': '64', 'total': '640.000'},
      {'denom': '20.000', 'quantity': '53', 'total': '1.060.000'},
      {'denom': '50.000', 'quantity': '331', 'total': '16.550.000'},
      {'denom': '100.000', 'quantity': '367', 'total': '36.700.000'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: const WatermarkWidget(
                opacity: 0.06,
                spacing: 120.0,
                rotation: -45.0,
                logoSize: 35.0,
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Denom',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Lembar',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...denominations.map(
                (denom) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          denom['denom']!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textBlack,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'X ${denom['quantity']}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textBlack,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '= ${denom['total']}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textBlack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotals() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: const WatermarkWidget(
                opacity: 0.06,
                spacing: 120.0,
                rotation: -45.0,
                logoSize: 35.0,
              ),
            ),
          ),
          Column(
            children: [
              _buildTotalRow('Total (Lembar)', '1.531'),
              _buildTotalRow('Total (Amount)', '55.503.000'),
              const SizedBox(height: 12),
              _buildTotalRow('Biaya Layanan', 'Rp. 28.000'),
              _buildTotalRow(
                'Total Transfer',
                'Rp. 56.555.000',
                isHighlighted: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(
    String label,
    String value, {
    bool isHighlighted = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isHighlighted
                    ? AppColors.primaryRed
                    : AppColors.textBlack,
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: isHighlighted ? AppColors.primaryRed : AppColors.textBlack,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Status Trx: ',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Success',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                'Date/Time: ',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                '10 July 2025 20:40:01',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textBlack,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: const Text(
        'Copy Struk transaksi ini digunakan sebagai tanda bukti transaksi yang sah',
        style: TextStyle(
          fontSize: 12,
          color: AppColors.textGray,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Download receipt functionality
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Unduh Bukti Setor',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Share functionality
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Bagikan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
