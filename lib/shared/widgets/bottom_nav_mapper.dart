import 'package:flutter/material.dart';
import '../../widgets/common/app_bottom_nav.dart';

class BottomNavMapper {
  static List<BottomNavItemData> getBottomNavItems({
    required String selectedRole,
    required String userRoleMobile,
  }) {
    if (selectedRole == 'CUSTOMER' ||
        selectedRole == 'PELANGGAN' ||
        userRoleMobile == 'CUSTOMER') {
      return [
        BottomNavItemData(icon: Icons.home, label: 'Beranda'),
        BottomNavItemData(icon: Icons.location_on, label: 'Lokasi'),
        BottomNavItemData(icon: Icons.history, label: 'Riwayat Transaksi'),
        BottomNavItemData(icon: Icons.person, label: 'Akun'),
      ];
    } else if (selectedRole == 'NON_MESIN') {
      return [
        BottomNavItemData(icon: Icons.home, label: 'Beranda'),
        BottomNavItemData(icon: Icons.history, label: 'Riwayat Layanan'),
        BottomNavItemData(icon: Icons.person, label: 'Akun'),
      ];
    } else if (selectedRole == 'MESIN') {
      return [
        BottomNavItemData(icon: Icons.home, label: 'Beranda'),
        BottomNavItemData(icon: Icons.history, label: 'Komisi'),
        BottomNavItemData(icon: Icons.person, label: 'Akun'),
      ];
    } else {
      return [
        BottomNavItemData(icon: Icons.home, label: 'Beranda'),
        BottomNavItemData(icon: Icons.history, label: 'Riwayat'),
        BottomNavItemData(icon: Icons.person, label: 'Akun'),
      ];
    }
  }
}
