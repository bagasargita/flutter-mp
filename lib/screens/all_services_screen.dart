import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AllServicesScreen extends StatelessWidget {
  const AllServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundWhite,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/MerahPutihLogo.svg'),
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
            textScaler: TextScaler.linear(1.0),
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
                    children: [
                      const Icon(
                        Icons.search,
                        color: AppColors.textGray,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Cari',
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
                const _CategoryTitle('Setor Tunai'),
                const SizedBox(height: 8),
                _ServiceRow(
                  services: const [
                    _ServiceIcon(
                      icon: 'assets/images/Mesin.png',
                      label: 'Mesin',
                    ),
                    _ServiceIcon(
                      icon: 'assets/images/Sales.png',
                      label: 'Sales',
                    ),
                    _ServiceIcon(
                      icon: 'assets/images/WarungGrosir.png',
                      label: 'Warung / Grosir',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
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
                const _CategoryTitle('Transfer'),
                const SizedBox(height: 8),
                _ServiceRow(
                  services: const [
                    _ServiceIcon(
                      icon: 'assets/images/KirimUang.png',
                      label: 'Kirim Uang',
                    ),
                    _ServiceIcon(
                      icon: 'assets/images/SetorTunai.png',
                      label: 'Setor Tunai',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const _CategoryTitle('Pembayaran'),
                const SizedBox(height: 8),
                _ServiceRow(
                  services: const [
                    _ServiceIcon(
                      icon: 'assets/images/ListrikPln.png',
                      label: 'Listrik PLN',
                    ),
                    _ServiceIcon(
                      icon: 'assets/images/RiwayatTransaksi.png',
                      label: 'Riwayat Transaksi',
                    ),
                  ],
                ),
              ],
            ),
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
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textBlack,
      ),
      textScaler: TextScaler.linear(1.0),
    );
  }
}

class _ServiceRow extends StatelessWidget {
  final List<_ServiceIcon> services;

  const _ServiceRow({required this.services});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: services.map((service) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: service,
          ),
        );
      }).toList(),
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
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Image.asset(icon, width: 48, height: 48),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textBlack,
          ),
          textAlign: TextAlign.center,
          textScaler: TextScaler.linear(1.0),
        ),
      ],
    );
  }
}
