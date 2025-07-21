import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AllServicesScreen extends StatelessWidget {
  const AllServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
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
        title: const Text(
          'All Services',
          style: TextStyle(
            color: AppColors.textBlack,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.textGray),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: AppColors.textGray, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Cari',
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
              // Setor Tunai
              const _CategoryTitle('Setor Tunai'),
              const SizedBox(height: 8),
              _ServiceRow(
                services: const [
                  _ServiceIcon(icon: 'assets/images/Mesin.png', label: 'Mesin'),
                  _ServiceIcon(icon: 'assets/images/Sales.png', label: 'Sales'),
                  _ServiceIcon(
                    icon: 'assets/images/WarungGrosir.png',
                    label: 'Warung / Grosir',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Paket
              const _CategoryTitle('Paket'),
              const SizedBox(height: 8),
              _ServiceRow(
                services: const [
                  _ServiceIcon(
                    icon: 'assets/images/Pickup.png',
                    label: 'Pickup',
                  ),
                  _ServiceIcon(
                    icon: 'assets/images/Delivery.png',
                    label: 'Delivery',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Tagihan
              const _CategoryTitle('Tagihan'),
              const SizedBox(height: 8),
              _ServiceRow(
                services: const [
                  _ServiceIcon(
                    icon: 'assets/images/ListrikPln.png',
                    label: 'Listrik PLN',
                  ),
                  _ServiceIcon(
                    icon: 'assets/images/InternetTV.png',
                    label: 'Internet & TV Kabel',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Isi Ulang
              const _CategoryTitle('Isi Ulang'),
              const SizedBox(height: 8),
              _ServiceRow(
                services: const [
                  _ServiceIcon(icon: 'assets/images/Pulsa.png', label: 'Pulsa'),
                  _ServiceIcon(
                    icon: 'assets/images/PaketData.png',
                    label: 'Paket Data',
                  ),
                  _ServiceIcon(icon: 'assets/images/Gopay.png', label: 'Gopay'),
                ],
              ),
              const SizedBox(height: 8),
              _ServiceRow(
                services: const [
                  _ServiceIcon(icon: 'assets/images/Dana.png', label: 'Dana'),
                  _ServiceIcon(icon: 'assets/images/Ovo.png', label: 'OVO'),
                  _ServiceIcon(
                    icon: 'assets/images/Bukalapak.png',
                    label: 'Bukalapak',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Others
              const _CategoryTitle('Others'),
              const SizedBox(height: 8),
              _ServiceRow(
                services: const [
                  _ServiceIcon(
                    icon: 'assets/images/KirimUang.png',
                    label: 'Kirim Uang',
                  ),
                  _ServiceIcon(
                    icon: 'assets/images/Belanja.png',
                    label: 'Belanja',
                  ),
                  _ServiceIcon(
                    icon: 'assets/images/Pinjaman.png',
                    label: 'Pinjaman',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _ServiceRow(
                services: const [
                  _ServiceIcon(
                    icon: 'assets/images/NonTunai.png',
                    label: 'Non tunai',
                  ),
                  _ServiceIcon(
                    icon: 'assets/images/Transaksi.png',
                    label: 'Transaksi',
                  ),
                  _ServiceIcon(
                    icon: 'assets/images/AkunBank.png',
                    label: 'Akun Bank',
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryTitle extends StatelessWidget {
  final String title;
  const _CategoryTitle(this.title);
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textBlack,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
    );
  }
}

class _ServiceRow extends StatelessWidget {
  final List<_ServiceIcon> services;
  const _ServiceRow({required this.services});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: services
          .map(
            (s) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: s,
              ),
            ),
          )
          .toList(),
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
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.textGray.withOpacity(0.06),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Image.asset(
              icon,
              width: 32,
              height: 32,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textBlack,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
