import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
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
  final MapController _mapController = MapController();

  // Current user location
  LatLng? _currentLocation;

  // Dummy data for ATMs/machines in Jakarta with real coordinates
  final List<Map<String, dynamic>> _machines = [
    {
      'name': 'Grosir Pondok Pinang',
      'maxAmount': 'Rp. 5.000.000,-',
      'distance': '90 m',
      'address': 'Jl. Pondok Pinang Raya No. 45',
      'latitude': -6.2606,
      'longitude': 106.7816,
      'type': 'ATM',
      'status': 'Available',
    },
    {
      'name': 'WSMM Pondok Indah',
      'maxAmount': 'Rp. 5.000.000,-',
      'distance': '1.2 km',
      'address': 'Jl. Metro Pondok Indah No. 12',
      'latitude': -6.2654,
      'longitude': 106.7834,
      'type': 'CDM',
      'status': 'Available',
    },
    {
      'name': 'Warung Madura Deplu',
      'maxAmount': 'Rp. 5.000.000,-',
      'distance': '5.3 km',
      'address': 'Jl. Deplu Raya No. 78',
      'latitude': -6.2088,
      'longitude': 106.8456,
      'type': 'ATM',
      'status': 'Available',
    },
    {
      'name': 'Bank Central Asia - SCBD',
      'maxAmount': 'Rp. 10.000.000,-',
      'distance': '2.1 km',
      'address': 'Jl. Jend. Sudirman No. 52-53',
      'latitude': -6.2088,
      'longitude': 106.8456,
      'type': 'ATM',
      'status': 'Available',
    },
    {
      'name': 'Bank Mandiri - Thamrin',
      'maxAmount': 'Rp. 7.500.000,-',
      'distance': '3.5 km',
      'address': 'Jl. M.H. Thamrin No. 5',
      'latitude': -6.1865,
      'longitude': 106.8243,
      'type': 'CDM',
      'status': 'Available',
    },
    {
      'name': 'Bank Negara Indonesia - Sudirman',
      'maxAmount': 'Rp. 8.000.000,-',
      'distance': '4.2 km',
      'address': 'Jl. Jend. Sudirman Kav. 1',
      'latitude': -6.2088,
      'longitude': 106.8456,
      'type': 'ATM',
      'status': 'Available',
    },
    {
      'name': 'Indomaret - Kebayoran Baru',
      'maxAmount': 'Rp. 3.000.000,-',
      'distance': '1.8 km',
      'address': 'Jl. Kebayoran Baru No. 23',
      'latitude': -6.2456,
      'longitude': 106.7890,
      'type': 'CDM',
      'status': 'Available',
    },
    {
      'name': 'Alfamart - Senayan',
      'maxAmount': 'Rp. 2.500.000,-',
      'distance': '2.7 km',
      'address': 'Jl. Asia Afrika No. 8',
      'latitude': -6.2088,
      'longitude': 106.8456,
      'type': 'ATM',
      'status': 'Available',
    },
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });

      // Center map on current location
      _mapController.move(_currentLocation!, 15.0);
    } catch (e) {
      print('Error getting location: $e');
      // Set default location to Jakarta center if location fails
      setState(() {
        _currentLocation = const LatLng(-6.2088, 106.8456);
      });
    }
  }

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
    if (_currentLocation == null) {
      return Container(
        height: 200,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      height: 200,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _currentLocation!,
            initialZoom: 15.0,
            minZoom: 10.0,
            maxZoom: 18.0,
          ),
          children: [
            // OpenStreetMap tiles
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.smartmob.app',
            ),

            // Current location marker
            MarkerLayer(
              markers: [
                Marker(
                  point: _currentLocation!,
                  width: 30,
                  height: 30,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),

            // Machine/ATM markers
            MarkerLayer(
              markers: _machines.map((machine) {
                return Marker(
                  point: LatLng(
                    machine['latitude'] as double,
                    machine['longitude'] as double,
                  ),
                  width: 40,
                  height: 40,
                  child: GestureDetector(
                    onTap: () {
                      _showMachineInfo(machine);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _getMachineColor(machine['type']),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        _getMachineIcon(machine['type']),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMachineColor(String type) {
    switch (type) {
      case 'ATM':
        return Colors.blue;
      case 'CDM':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  IconData _getMachineIcon(String type) {
    switch (type) {
      case 'ATM':
        return Icons.account_balance;
      case 'CDM':
        return Icons.payment;
      default:
        return Icons.location_on;
    }
  }

  void _showMachineInfo(Map<String, dynamic> machine) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _getMachineColor(
                      machine['type'],
                    ).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getMachineIcon(machine['type']),
                    color: _getMachineColor(machine['type']),
                    size: 25,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        machine['name'],
                        style: AppText.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        machine['type'],
                        style: AppText.bodySmall.copyWith(
                          color: AppColors.textGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Max Amount', machine['maxAmount']),
            _buildInfoRow('Address', machine['address']),
            _buildInfoRow('Status', machine['status']),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  print(
                    'Pilih Mesin Ini button tapped for: ${machine['name']}',
                  ); // Debug print
                  Navigator.pop(context); // Close bottom sheet

                  // Navigate to machine details screen and wait for result
                  final result = await Navigator.push(
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

                  print(
                    'Returned from machine details (bottom sheet): $result',
                  ); // Debug print
                  // If machine was selected, return the data to Setor Tunai screen
                  if (result != null && result is Map<String, dynamic>) {
                    print(
                      'Returning machine data to Setor Tunai (bottom sheet): $result',
                    ); // Debug print
                    Navigator.pop(context, result);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Pilih Mesin Ini',
                  style: AppText.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: AppText.bodySmall.copyWith(
                color: AppColors.textGray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppText.bodySmall.copyWith(color: AppColors.textBlack),
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
      onTap: () async {
        print('Machine item tapped: ${machine['name']}'); // Debug print
        // Navigate to machine details screen and wait for result
        final result = await Navigator.push(
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

        print('Returned from machine details: $result'); // Debug print
        // If machine was selected, return the data to Setor Tunai screen
        if (result != null && result is Map<String, dynamic>) {
          print(
            'Returning machine data to Setor Tunai: $result',
          ); // Debug print
          Navigator.pop(context, result);
        }
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
                color: _getMachineColor(machine['type']).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getMachineIcon(machine['type']),
                color: _getMachineColor(machine['type']),
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
