import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/constants/app_text.dart';
import 'package:smart_mob/widgets/common/app_top_bar.dart';
import 'package:smart_mob/core/services/location_service.dart';

class SetorTunaiLocationScreen extends StatefulWidget {
  const SetorTunaiLocationScreen({super.key});

  @override
  State<SetorTunaiLocationScreen> createState() =>
      _SetorTunaiLocationScreenState();
}

class _SetorTunaiLocationScreenState extends State<SetorTunaiLocationScreen> {
  final MapController _mapController = MapController();
  String _selectedLocationType = 'Lokasi Partner';
  String _selectedStatus = '';
  LatLng? _currentLocation;

  final List<Map<String, dynamic>> _locations = [
    {
      'name': 'Grosir Pondok Pinang',
      'address': 'Jalan Ciledug Raya no 11',
      'info': 'Available Max Rp. 5.000.000,-',
      'distance': '50 m',
      'type': 'Lokasi Partner',
      'status': 'Available',
      'icon': Icons.shopping_bag,
      'iconColor': const Color(0xFF8B5CF6),
      'latitude': -6.2606,
      'longitude': 106.7816,
    },
    {
      'name': 'WSSM Pondok Indah',
      'address': 'Jalan Ciledug Raya no 11',
      'info': 'Available Max Rp. 5.000.000,-',
      'distance': '50 m',
      'type': 'Lokasi Partner',
      'status': 'Available',
      'icon': Icons.shopping_bag,
      'iconColor': const Color(0xFF8B5CF6),
      'latitude': -6.2654,
      'longitude': 106.7834,
    },
    {
      'name': 'Toserba Pondok Indah',
      'address': 'Jalan Ciledug Raya no 11',
      'info': 'Available Max Rp. 5.000.000,-',
      'distance': '50 m',
      'type': 'Lokasi Partner',
      'status': 'Available',
      'icon': Icons.shopping_bag,
      'iconColor': const Color(0xFF8B5CF6),
      'latitude': -6.2088,
      'longitude': 106.8456,
    },
    {
      'name': 'Wisma ANTAM',
      'address': 'Jalan Metro Pondok Indah',
      'info': 'Available Max Rp. 5.000.000,-',
      'distance': '9.8 Km',
      'type': 'ATM/CDM',
      'status': 'Available',
      'icon': Icons.atm,
      'iconColor': const Color(0xFFE53E3E),
      'latitude': -6.1865,
      'longitude': 106.8243,
    },
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final location = await LocationService.getCurrentLocation();
    setState(() {
      _currentLocation = location ?? const LatLng(-6.2088, 106.8456);
    });

    if (_currentLocation != null) {
      _mapController.move(_currentLocation!, 15.0);
    }
  }

  List<Map<String, dynamic>> get _filteredLocations {
    return _locations.where((location) {
      bool matchesType =
          _selectedLocationType.isEmpty ||
          location['type'] == _selectedLocationType;
      bool matchesStatus =
          _selectedStatus.isEmpty || location['status'] == _selectedStatus;
      return matchesType && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: Stack(children: [_buildMapView(), _buildLocationList()]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Lokasi',
              style: AppText.heading3.copyWith(
                color: AppColors.textBlack,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: _showFilterPopup,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.tune, color: Colors.grey[600], size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    if (_currentLocation == null) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _currentLocation!,
            initialZoom: 15.0,
            minZoom: 10.0,
            maxZoom: 18.0,
          ),
          children: [
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
              markers: _filteredLocations.asMap().entries.map((entry) {
                final index = entry.key;
                final location = entry.value;
                final isSelected = index == 0;

                return Marker(
                  point: LatLng(
                    location['latitude'] as double,
                    location['longitude'] as double,
                  ),
                  width: isSelected ? 40 : 32,
                  height: isSelected ? 40 : 32,
                  child: GestureDetector(
                    onTap: () {
                      _showLocationInfo(location);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: location['iconColor'],
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.white, width: 3)
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        location['icon'],
                        color: Colors.white,
                        size: isSelected ? 20 : 16,
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

  void _showLocationInfo(Map<String, dynamic> location) {
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
                    color: location['iconColor'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    location['icon'],
                    color: location['iconColor'],
                    size: 25,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location['name'],
                        style: AppText.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        location['type'],
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
            _buildInfoRow('Address', location['address']),
            _buildInfoRow('Info', location['info']),
            _buildInfoRow('Distance', location['distance']),
            _buildInfoRow('Status', location['status']),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Pilih Lokasi Ini',
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

  Widget _buildLocationList() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shrinkWrap: true,
                itemCount: _filteredLocations.length,
                itemBuilder: (context, index) {
                  final location = _filteredLocations[index];
                  return _buildLocationItem(location);
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationItem(Map<String, dynamic> location) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: location['iconColor'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              location['icon'],
              color: location['iconColor'],
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location['name'],
                  style: TextStyle(
                    color: AppColors.textBlack,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location['address'],
                  style: TextStyle(
                    color: AppColors.textGray,
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location['info'],
                  style: TextStyle(
                    color: AppColors.textGray,
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Text(
            location['distance'],
            style: TextStyle(
              color: AppColors.textGray,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Roboto',
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterPopup() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => _buildFilterPopup(setModalState),
      ),
    );
  }

  Widget _buildFilterPopup(StateSetter setModalState) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filters',
                    style: AppText.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlack,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedLocationType = '';
                        _selectedStatus = '';
                      });
                      setModalState(() {});
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Clear',
                      style: AppText.bodyMedium.copyWith(
                        color: AppColors.primaryRed,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Text(
                'Locations',
                style: AppText.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlack,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildFilterChip(
                    'ATM/CDM',
                    _selectedLocationType == 'ATM/CDM',
                    Icons.atm,
                    const Color(0xFFE53E3E),
                    (value) {
                      setState(() {
                        _selectedLocationType = value ? 'ATM/CDM' : '';
                      });
                      setModalState(() {});
                    },
                  ),
                  _buildFilterChip(
                    'Lokasi Partner',
                    _selectedLocationType == 'Lokasi Partner',
                    Icons.shopping_bag,
                    const Color(0xFF8B5CF6),
                    (value) {
                      setState(() {
                        _selectedLocationType = value ? 'Lokasi Partner' : '';
                      });
                      setModalState(() {});
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Text(
                'Status',
                style: AppText.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlack,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildFilterChip(
                    'Available',
                    _selectedStatus == 'Available',
                    null,
                    Colors.grey,
                    (value) {
                      setState(() {
                        _selectedStatus = value ? 'Available' : '';
                      });
                      setModalState(() {});
                    },
                  ),
                  _buildFilterChip(
                    'Not Available',
                    _selectedStatus == 'Not Available',
                    null,
                    Colors.grey,
                    (value) {
                      setState(() {
                        _selectedStatus = value ? 'Not Available' : '';
                      });
                      setModalState(() {});
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Show results (${_filteredLocations.length})',
                    style: AppText.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    bool isSelected,
    IconData? icon,
    Color iconColor,
    Function(bool) onChanged,
  ) {
    return GestureDetector(
      onTap: () => onChanged(!isSelected),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? iconColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? iconColor : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: isSelected ? Colors.white : iconColor,
                size: 16,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: AppText.bodySmall.copyWith(
                color: isSelected ? Colors.white : AppColors.textGray,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
