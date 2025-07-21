import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text.dart';
import 'card_details_screen.dart';
import 'all_services_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/MP-Logo.png'),
            radius: 20,
          ),
        ),
        title: Text(
          AppText.appName,
          style: const TextStyle(
            color: AppColors.textBlack,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.textGray),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Balance Card
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CardDetailsScreen(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryRed, AppColors.primaryPurple],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryRed.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Saldo yang tersedia',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Rp. 10.350.000',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: const [
                          Text(
                            '**** **** **** 8635',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              letterSpacing: 2,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.credit_card,
                            color: Colors.white,
                            size: 28,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Pemegang kartu',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      const Text(
                        'Mr. John Doe',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Services Grid
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 24,
                childAspectRatio: 1.3, // Fix overflow by making cells taller
                children: [
                  _ServiceIcon(
                    icon: 'assets/images/SetorTunai.png',
                    label: 'Setor Tunai',
                  ),
                  _ServiceIcon(
                    icon: 'assets/images/ListrikPln.png',
                    label: 'Listrik PLN',
                  ),
                  _ServiceIcon(
                    icon: 'assets/images/RiwayatTransaksi.png',
                    label: 'Riwayat Transaksi',
                  ),
                  _ServiceIcon(
                    icon: 'assets/images/KirimUang.png',
                    label: 'Kirim Uang',
                  ),
                  _ServiceIcon(
                    icon: 'assets/images/WarungGrosir.png',
                    label: 'Warung / Grosir',
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AllServicesScreen(),
                        ),
                      );
                    },
                    child: _ServiceIcon(
                      icon: 'assets/images/IconLainnya.png',
                      label: 'Lainnya',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Transactions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Transactions',
                    style: TextStyle(
                      color: AppColors.textBlack,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'All transactions',
                    style: TextStyle(
                      color: AppColors.primaryRed,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _TransactionItem(
                icon: Icons.account_balance,
                title: 'Setor Mesin',
                subtitle: 'Setoran 03/10/25',
                amount: '+Rp. 1.500.000',
                amountColor: AppColors.successGreen,
              ),
              _TransactionItem(
                icon: Icons.local_shipping,
                title: 'Pickup Barang',
                subtitle: 'SRC Lebak Bulus',
                amount: '-Rp. 9.500',
                amountColor: AppColors.errorRed,
              ),
              _TransactionItem(
                icon: Icons.receipt_long,
                title: 'Bayar Tagihan',
                subtitle: 'PLN Pascabayar',
                amount: '-Rp. 350.000',
                amountColor: AppColors.errorRed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceIcon extends StatelessWidget {
  final String icon;
  final String label;
  const _ServiceIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40, // Reduced size
          height: 40, // Reduced size
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.textGray.withOpacity(0.08),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Image.asset(
              icon,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ), // Reduced size
          ),
        ),
        const SizedBox(height: 4), // Slightly reduced spacing
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textBlack,
            fontSize: 11, // Reduced font size
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;
  final Color amountColor;
  const _TransactionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.amountColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.backgroundLight,
          child: Icon(icon, color: AppColors.primaryRed),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.textBlack,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: AppColors.textGray, fontSize: 12),
        ),
        trailing: Text(
          amount,
          style: TextStyle(
            color: amountColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
