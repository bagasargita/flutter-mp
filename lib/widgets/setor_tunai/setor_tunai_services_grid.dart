import 'package:flutter/material.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/constants/app_text.dart';
import 'package:smart_mob/screens/setor_tunai/setor_tunai_machine_selection_screen.dart';
import 'package:smart_mob/screens/setor_tunai/setor_tunai_history_screen.dart';
import 'package:smart_mob/screens/setor_tunai/setor_tunai_location_screen.dart';
import 'package:smart_mob/screens/setor_tunai/setor_tunai_help_screen.dart';

class SetorTunaiServicesGrid extends StatelessWidget {
  const SetorTunaiServicesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      {
        'name': 'Setor',
        'image': 'assets/images/SetorTunai.png',
        'color': Colors.red,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SetorTunaiMachineSelectionScreen(),
          ),
        ),
      },
      {
        'name': 'Riwayat',
        'image': 'assets/images/RiwayatTransaksi.png',
        'color': Colors.blue,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SetorTunaiHistoryScreen(),
          ),
        ),
      },
      {
        'name': 'Lokasi',
        'image': 'assets/images/IconLainnya.png',
        'color': Colors.green,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SetorTunaiLocationScreen(),
          ),
        ),
      },
      {
        'name': 'Bantuan',
        'image': 'assets/images/IconLainnya.png',
        'color': Colors.orange,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SetorTunaiHelpScreen(),
          ),
        ),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return _buildServiceItem(service);
      },
    );
  }

  Widget _buildServiceItem(Map<String, dynamic> service) {
    return GestureDetector(
      onTap: service['onTap'],
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(243, 239, 239, 1),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: service['color'].withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                service['image'],
                width: 32,
                height: 32,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              service['name'],
              style: AppText.bodyMedium.copyWith(
                color: AppColors.textBlack,
                fontWeight: FontWeight.w600,
              ),
              textScaler: TextScaler.linear(1.0),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
