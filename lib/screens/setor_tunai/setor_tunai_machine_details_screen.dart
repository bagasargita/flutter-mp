import 'package:flutter/material.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/constants/app_text.dart';
import 'package:smart_mob/widgets/common/app_top_bar.dart';
import 'package:smart_mob/screens/setor_tunai/setor_tunai_qr_screen.dart';

class SetorTunaiMachineDetailsScreen extends StatefulWidget {
  final String machineName;
  final String maxAmount;
  final String distance;
  final String address;

  const SetorTunaiMachineDetailsScreen({
    super.key,
    required this.machineName,
    required this.maxAmount,
    required this.distance,
    required this.address,
  });

  @override
  State<SetorTunaiMachineDetailsScreen> createState() =>
      _SetorTunaiMachineDetailsScreenState();
}

class _SetorTunaiMachineDetailsScreenState
    extends State<SetorTunaiMachineDetailsScreen> {
  final bool _hasOutstandingTransaction = false;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        body: SafeArea(
          child: Column(
            children: [
              const AppTopBar(title: 'Mesin', showBack: true),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      if (_hasOutstandingTransaction)
                        _buildOutstandingSection(),
                      _buildMachineInfo(),
                      const SizedBox(height: 32),
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

  Widget _buildOutstandingSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
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
            style: AppText.bodySmall.copyWith(color: AppColors.textGray),
            textScaler: TextScaler.linear(1.0),
          ),
          const SizedBox(height: 4),
          Text(
            'JL. SMP 87 Pondok Pinang',
            style: AppText.bodySmall.copyWith(color: AppColors.textGray),
            textScaler: TextScaler.linear(1.0),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
            ),
            child: Text(
              '00:34:55',
              style: AppText.bodySmall.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
              textScaler: TextScaler.linear(1.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMachineInfo() {
    return Column(
      children: [
        _buildInfoSection(
          'Address',
          widget.machineName,
          '${widget.address}, Jakarta Selatan, RT.3/RW.12, Pd. Pinang. Kec. Kby. Lama, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 13210',
          Icons.location_on,
          Colors.red,
        ),
        const SizedBox(height: 20),
        _buildInfoSection(
          'Jam Layanan',
          '09:00 - 22:00',
          'Buka setiap hari',
          Icons.access_time,
          Colors.blue,
        ),
        const SizedBox(height: 20),
        _buildInfoSection(
          'Kapasitas',
          widget.maxAmount,
          'Maksimal deposit per transaksi',
          Icons.account_balance_wallet,
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildInfoSection(
    String title,
    String subtitle,
    String description,
    IconData icon,
    Color color,
  ) {
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
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppText.bodySmall.copyWith(
                    color: AppColors.textGray,
                    fontWeight: FontWeight.w500,
                  ),
                  textScaler: TextScaler.linear(1.0),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppText.bodyMedium.copyWith(
                    color: AppColors.textBlack,
                    fontWeight: FontWeight.w600,
                  ),
                  textScaler: TextScaler.linear(1.0),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppText.bodySmall.copyWith(color: AppColors.textGray),
                  textScaler: TextScaler.linear(1.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SetorTunaiQRScreen()),
          );
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
          _hasOutstandingTransaction ? 'Mulai Setor' : 'Pilih',
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
