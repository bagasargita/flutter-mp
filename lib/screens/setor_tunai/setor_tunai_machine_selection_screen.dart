import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/constants/app_text.dart';
import 'package:smart_mob/widgets/common/app_top_bar.dart';
import 'package:smart_mob/screens/setor_tunai/setor_tunai_machine_details_screen.dart';
import 'package:smart_mob/core/services/location_service.dart';
import 'package:smart_mob/core/api/api_client.dart';
import 'dart:io';

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

  LatLng? _currentLocation;
  bool _isMapReady = false;
  bool _isOnline = true;
  final List<Map<String, dynamic>> _machines = [];

  @override
  void initState() {
    super.initState();
    _checkConnectivity().then((_) => _getCurrentLocation());
  }

  Future<void> _checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('tile.openstreetmap.org');
      setState(() {
        _isOnline = result.isNotEmpty && result.first.rawAddress.isNotEmpty;
      });
    } catch (_) {
      setState(() {
        _isOnline = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    final location = await LocationService.getCurrentLocation();
    setState(() {
      _currentLocation = location ?? const LatLng(-6.2088, 106.8456);
    });

    if (_currentLocation != null) {
      if (_isMapReady) {
        _mapController.move(_currentLocation!, 15.0);
      }
    }

    await _fetchMachines();
  }

  Future<void> _fetchMachines() async {
    if (_currentLocation == null) return;
    try {
      final client = ApiClient.create();
      final response = await client.getMachineLocations(
        latitude: _currentLocation!.latitude,
        longitude: _currentLocation!.longitude,
        type: 'Mesin',
        status: 'Buka',
      );
      final data = response.data;
      final dynamic listRaw = (data is Map<String, dynamic>)
          ? (data['data'] ?? data['list'] ?? data['items'])
          : data;
      final List<dynamic> list = (listRaw is List) ? listRaw : <dynamic>[];
      final List<Map<String, dynamic>> parsed = list
          .map((item) {
            final Map<String, dynamic> m = (item as Map)
                .cast<String, dynamic>();
            final dynamic latRaw =
                m['coordinateLatitude'] ?? m['latitude'] ?? m['lat'];
            final dynamic lngRaw =
                m['coordinateLongitude'] ??
                m['longitude'] ??
                m['lng'] ??
                m['lon'];
            final double? lat = latRaw is num
                ? latRaw.toDouble()
                : double.tryParse((latRaw ?? '').toString());
            final double? lng = lngRaw is num
                ? lngRaw.toDouble()
                : double.tryParse((lngRaw ?? '').toString());
            final dynamic distanceRaw = m['distance'];
            final String distanceStr = distanceRaw == null
                ? '-'
                : (distanceRaw is num
                      ? '${distanceRaw.toStringAsFixed(1)} km'
                      : distanceRaw.toString());
            return {
              'name': m['name'] ?? m['location'] ?? 'Mesin',
              'maxAmount': m['description'] ?? '-',
              'distance': distanceStr,
              'address': m['addressStreet'] ?? m['address'] ?? '-',
              'latitude': lat ?? 0.0,
              'longitude': lng ?? 0.0,
              'type':
                  (m['locationType'] ?? m['type'] ?? 'ATM')
                      .toString()
                      .toUpperCase()
                      .contains('MACHINE')
                  ? 'ATM'
                  : 'ATM',
              'status': (m['currentStatus'] ?? '').toString() == 'Buka'
                  ? 'Available'
                  : 'Not Available',
            };
          })
          .where(
            (e) =>
                (e['latitude'] as double) != 0.0 &&
                (e['longitude'] as double) != 0.0,
          )
          .toList();

      setState(() {
        _machines
          ..clear()
          ..addAll(parsed);
      });
    } catch (_) {
      setState(() {});
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
      height: 380,
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
            onMapReady: () {
              _isMapReady = true;
              if (_currentLocation != null) {
                _mapController.move(_currentLocation!, 15.0);
              }
            },
          ),
          children: [
            if (_isOnline)
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.smartmob.app',
              ),
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
                        style: AppText.kaiseiRegular.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        machine['type'],
                        style: AppText.kaiseiRegular.copyWith(
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
                  Navigator.pop(context);

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

                  if (result != null && result is Map<String, dynamic>) {
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
                  style: AppText.kaiseiRegular.copyWith(
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
              style: AppText.kaiseiRegular.copyWith(
                color: AppColors.textGray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppText.kaiseiRegular.copyWith(color: AppColors.textBlack),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 12),
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

        if (result != null && result is Map<String, dynamic>) {
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
                    style: AppText.kaiseiRegular.copyWith(
                      color: AppColors.textBlack,
                      fontWeight: FontWeight.w600,
                    ),
                    textScaler: TextScaler.linear(1.0),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Available Max ${machine['maxAmount']}',
                    style: AppText.kaiseiRegular.copyWith(
                      color: AppColors.textGray,
                    ),
                    textScaler: TextScaler.linear(1.0),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    machine['address'],
                    style: AppText.kaiseiRegular.copyWith(
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
                style: AppText.kaiseiRegular.copyWith(
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
