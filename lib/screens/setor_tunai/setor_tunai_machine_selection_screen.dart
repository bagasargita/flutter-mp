import 'package:flutter/material.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/constants/app_text.dart';
import 'package:smart_mob/widgets/common/app_top_bar.dart';
import 'package:smart_mob/screens/setor_tunai/setor_tunai_machine_details_screen.dart';

class SetorTunaiMachineSelectionScreen extends StatefulWidget {
  const SetorTunaiMachineSelectionScreen({super.key});

  @override
  State<SetorTunaiMachineSelectionScreen> createState() =>
      _SetorTunaiMachineSelectionScreenState();
}

class _SetorTunaiMachineSelectionScreenState
    extends State<SetorTunaiMachineSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _machines = [
    {
      'name': 'Grosir Pondok Pinang',
      'maxAmount': 'Rp. 5.000.000,-',
      'distance': '90 m',
      'address': 'Jl. Pondok Pinang Raya No. 45',
    },
    {
      'name': 'WSMM Pondok Indah',
      'maxAmount': 'Rp. 5.000.000,-',
      'distance': '1.2 km',
      'address': 'Jl. Metro Pondok Indah No. 12',
    },
    {
      'name': 'Warung Madura Deplu',
      'maxAmount': 'Rp. 5.000.000,-',
      'distance': '5.3 km',
      'address': 'Jl. Deplu Raya No. 78',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        body: SafeArea(
          child: Column(
            children: [
              const AppTopBar(title: 'Setor', showBack: true),
              Expanded(
                child: Column(
                  children: [
                    _buildMapSection(),
                    _buildSearchBar(),
                    Expanded(child: _buildMachineList()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapSection() {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 8),
                Text(
                  'Map View',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey[300]!),
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
          Icon(Icons.search, color: Colors.grey[400], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Cari',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMachineList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _machines.length,
      itemBuilder: (context, index) {
        final machine = _machines[index];
        return _buildMachineItem(machine);
      },
    );
  }

  Widget _buildMachineItem(Map<String, dynamic> machine) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SetorTunaiMachineDetailsScreen(
              machineName: machine['name'],
              maxAmount: machine['maxAmount'],
              distance: machine['distance'],
              address: machine['address'],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
                color: Colors.blue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on,
                color: Colors.blue,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    machine['name'],
                    style: AppText.bodyMedium.copyWith(
                      color: AppColors.textBlack,
                      fontWeight: FontWeight.w600,
                    ),
                    textScaler: TextScaler.linear(1.0),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Available Max ${machine['maxAmount']}',
                    style: AppText.bodySmall.copyWith(
                      color: AppColors.textGray,
                    ),
                    textScaler: TextScaler.linear(1.0),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    machine['address'],
                    style: AppText.bodySmall.copyWith(
                      color: AppColors.textGray,
                    ),
                    textScaler: TextScaler.linear(1.0),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Text(
                machine['distance'],
                style: AppText.bodySmall.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
                textScaler: TextScaler.linear(1.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
