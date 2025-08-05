import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textBlack),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: AppColors.textBlack,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Mark all read',
              style: TextStyle(
                color: AppColors.primaryRed,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _NotificationItem(
            icon: Icons.account_balance,
            title: 'Setor Tunai Berhasil',
            subtitle: 'Setoran Anda sebesar Rp 500.000 telah berhasil diproses',
            time: '2 menit yang lalu',
            isUnread: true,
            onTap: () {},
          ),
          _NotificationItem(
            icon: Icons.payment,
            title: 'Pembayaran PLN Berhasil',
            subtitle:
                'Pembayaran tagihan listrik untuk bulan Oktober telah berhasil',
            time: '1 jam yang lalu',
            isUnread: true,
            onTap: () {},
          ),
          _NotificationItem(
            icon: Icons.local_shipping,
            title: 'Pickup Barang Dijadwalkan',
            subtitle:
                'Pickup barang Anda telah dijadwalkan untuk besok pukul 09:00',
            time: '3 jam yang lalu',
            isUnread: false,
            onTap: () {},
          ),
          _NotificationItem(
            icon: Icons.security,
            title: 'Perubahan Password',
            subtitle: 'Password Anda telah berhasil diubah',
            time: '1 hari yang lalu',
            isUnread: false,
            onTap: () {},
          ),
          _NotificationItem(
            icon: Icons.card_giftcard,
            title: 'Promo Spesial',
            subtitle: 'Dapatkan cashback 10% untuk transaksi pertama Anda',
            time: '2 hari yang lalu',
            isUnread: false,
            onTap: () {},
          ),
          _NotificationItem(
            icon: Icons.system_update,
            title: 'Update Aplikasi',
            subtitle:
                'Versi baru SMARTMobs tersedia. Update sekarang untuk fitur terbaru',
            time: '3 hari yang lalu',
            isUnread: false,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final bool isUnread;
  final VoidCallback onTap;

  const _NotificationItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.isUnread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.backgroundLight,
              child: Icon(icon, color: AppColors.primaryRed),
            ),
            if (isUnread)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          title,
          style: TextStyle(
            color: AppColors.textBlack,
            fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: AppColors.textGray, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(color: AppColors.textGray, fontSize: 12),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
