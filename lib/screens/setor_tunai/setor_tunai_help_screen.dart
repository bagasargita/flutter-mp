import 'package:flutter/material.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/constants/app_text.dart';
import 'package:smart_mob/widgets/common/app_top_bar.dart';

class SetorTunaiHelpScreen extends StatelessWidget {
  const SetorTunaiHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        body: SafeArea(
          child: Column(
            children: [
              const AppTopBar(title: 'Bantuan', showBack: true),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildHelpSection(
                        'Cara Setor Tunai',
                        '1. Pilih mesin setor terdekat\n2. Pindai QR code yang muncul\n3. Masukkan uang ke mesin\n4. Konfirmasi jumlah setoran',
                        Icons.help_outline,
                        Colors.blue,
                      ),
                      const SizedBox(height: 20),
                      _buildHelpSection(
                        'Jam Operasional',
                        'Mesin setor tersedia 24/7\nLayanan customer support:\n09:00 - 22:00 WIB',
                        Icons.access_time,
                        Colors.green,
                      ),
                      const SizedBox(height: 20),
                      _buildHelpSection(
                        'Limit Transaksi',
                        'Minimal: Rp. 10.000\nMaksimal: Rp. 5.000.000\nper transaksi',
                        Icons.account_balance_wallet,
                        Colors.orange,
                      ),
                      const SizedBox(height: 20),
                      _buildHelpSection(
                        'Kontak Bantuan',
                        'WhatsApp: +62 812-3456-7890\nEmail: help@smartmobs.com\nCall Center: 1500-123',
                        Icons.contact_support,
                        Colors.purple,
                      ),
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

  Widget _buildHelpSection(
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: AppText.bodyLarge.copyWith(
                    color: AppColors.textBlack,
                    fontWeight: FontWeight.w600,
                  ),
                  textScaler: TextScaler.linear(1.0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: AppText.bodyMedium.copyWith(
              color: AppColors.textGray,
              height: 1.5,
            ),
            textScaler: TextScaler.linear(1.0),
          ),
        ],
      ),
    );
  }
}
