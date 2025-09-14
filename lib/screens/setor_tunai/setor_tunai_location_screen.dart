import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:merah_putih/constants/app_colors.dart';
import 'package:merah_putih/constants/app_text.dart';
import 'package:merah_putih/core/services/location_service.dart';
import 'package:merah_putih/core/api/api_client.dart';
import 'dart:io';
import 'package:merah_putih/screens/setor_tunai/setor_tunai_location_list_screen.dart';

class SetorTunaiLocationScreen extends StatefulWidget {
  const SetorTunaiLocationScreen({super.key});

  @override
  State<SetorTunaiLocationScreen> createState() =>
      _SetorTunaiLocationScreenState();
}

class _SetorTunaiLocationScreenState extends State<SetorTunaiLocationScreen> {
  final MapController _mapController = MapController();
  String _selectedLocationType = '';
  String _selectedStatus = '';
  String? _requestType;
  String? _requestStatus;
  LatLng? _currentLocation;
  bool _isMapReady = false;
  bool _isOnline = true;

  final List<Map<String, dynamic>> _locations = [];

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
    await _fetchLocations();
  }

  List<Map<String, dynamic>> get _filteredLocations {
    return _locations;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Buka':
        return Colors.green[700]!;
      case 'Tutup':
        return Colors.red[700]!;
      case 'Tidak Tersedia':
        return Colors.orange[700]!;
      default:
        return Colors.grey[700]!;
    }
  }

  Future<void> _fetchLocations() async {
    if (_currentLocation == null) return;
    setState(() {});
    try {
      final client = ApiClient.create();
      final response = await client.getMachineLocations(
        latitude: _currentLocation!.latitude,
        longitude: _currentLocation!.longitude,
        type: _requestType,
        status: _requestStatus,
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
            String distanceStr;
            if (distanceRaw == null) {
              distanceStr = '-';
            } else {
              final double? distanceNum = distanceRaw is num
                  ? distanceRaw.toDouble()
                  : double.tryParse(
                      distanceRaw.toString().replaceAll(RegExp('[^0-9.-]'), ''),
                    );
              if (distanceNum != null) {
                if (distanceNum < 1.0) {
                  final int meters = (distanceNum * 1000).round();
                  distanceStr = '$meters m';
                } else {
                  distanceStr = '${distanceNum.toStringAsFixed(2)} km';
                }
              } else {
                final String s = distanceRaw.toString();
                distanceStr = s.contains('km') ? s : '$s km';
              }
            }

            final String locationType =
                m['locationType'] ?? m['type'] ?? 'machine';
            final String currentStatus =
                m['currentStatus'] ?? m['status'] ?? 'Buka';
            final String operatingHours =
                '${m['operatingHourOpen'] ?? '00:00'} - ${m['operatingHourClose'] ?? '23:59'}';

            IconData iconData;
            Color iconColor;

            if (locationType.toLowerCase() == 'machine') {
              iconData = Icons.atm;
              iconColor = const Color(0xFFE53E3E);
            } else if (locationType.toLowerCase() == 'partner') {
              iconData = Icons.shopping_bag;
              iconColor = const Color(0xFF8B5CF6);
            } else {
              iconData = Icons.location_on;
              iconColor = const Color(0xFF4CAF50);
            }

            return {
              'name': m['name'] ?? m['location'] ?? 'Lokasi',
              'location': m['location'] ?? m['name'] ?? 'Lokasi',
              'address': m['addressStreet'] ?? m['address'] ?? '-',
              'description': m['description'] ?? m['info'] ?? '',
              'info': m['description'] ?? m['info'] ?? '',
              'distance': distanceStr,
              'type': locationType,
              'status': currentStatus,
              'operatingHours': operatingHours,
              'operatingHourOpen': m['operatingHourOpen'] ?? '00:00',
              'operatingHourClose': m['operatingHourClose'] ?? '23:59',
              'icon': iconData,
              'iconColor': iconColor,
              'latitude': lat ?? 0.0,
              'longitude': lng ?? 0.0,
            };
          })
          .where(
            (e) =>
                (e['latitude'] as double) != 0.0 &&
                (e['longitude'] as double) != 0.0,
          )
          .toList();

      setState(() {
        _locations
          ..clear()
          ..addAll(parsed);
      });
    } catch (e) {
      setState(() {});
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
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
              style: AppText.kaiseiBold.copyWith(
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
                errorTileCallback: (tile, error, stackTrace) {},
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
                        style: AppText.kaiseiRegular.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        location['type'],
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
            _buildInfoRow('Address', location['address']),
            _buildInfoRow('Description', location['description']),
            _buildInfoRow('Distance', location['distance']),
            _buildInfoRow('Operating Hours', location['operatingHours']),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SetorTunaiLocationListScreen(
                          locations: List<Map<String, dynamic>>.from(
                            _filteredLocations,
                          ),
                          selectedType: _selectedLocationType.isNotEmpty
                              ? _selectedLocationType
                              : null,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Tampilkan List',
                    style: AppText.kaiseiRegular.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
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
                  location['description'],
                  style: TextStyle(
                    color: AppColors.textGray,
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          location['status'],
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        location['status'],
                        style: TextStyle(
                          color: _getStatusColor(location['status']),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      location['operatingHours'],
                      style: TextStyle(
                        color: AppColors.textGray,
                        fontSize: 10,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
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
                    style: AppText.kaiseiRegular.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlack,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedLocationType = '';
                        _selectedStatus = '';
                        _requestType = null;
                        _requestStatus = null;
                      });
                      setModalState(() {});
                      _fetchLocations();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Clear',
                      style: AppText.kaiseiRegular.copyWith(
                        color: AppColors.primaryRed,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Text(
                'Tipe Lokasi',
                style: AppText.kaiseiRegular.copyWith(
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
                    'Mesin',
                    _selectedLocationType == 'Mesin',
                    Icons.atm,
                    const Color(0xFFE53E3E),
                    (value) {
                      setState(() {
                        _selectedLocationType = value ? 'Mesin' : '';
                        _requestType = value ? 'machine' : null;
                      });
                      setModalState(() {});
                    },
                  ),
                  _buildFilterChip(
                    'Non Mesin',
                    _selectedLocationType == 'Non Mesin',
                    Icons.shopping_bag,
                    const Color(0xFF8B5CF6),
                    (value) {
                      setState(() {
                        _selectedLocationType = value ? 'Non Mesin' : '';
                        _requestType = value ? 'partner' : null;
                      });
                      setModalState(() {});
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Text(
                'Status',
                style: AppText.kaiseiRegular.copyWith(
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
                    'Buka',
                    _selectedStatus == 'Buka',
                    null,
                    Colors.green,
                    (value) {
                      setState(() {
                        _selectedStatus = value ? 'Buka' : '';
                        _requestStatus = value ? 'Buka' : null;
                      });
                      setModalState(() {});
                    },
                  ),
                  _buildFilterChip(
                    'Tutup',
                    _selectedStatus == 'Tutup',
                    null,
                    Colors.red,
                    (value) {
                      setState(() {
                        _selectedStatus = value ? 'Tutup' : '';
                        _requestStatus = value ? 'Tutup' : null;
                      });
                      setModalState(() {});
                    },
                  ),
                  _buildFilterChip(
                    'Tidak Tersedia',
                    _selectedStatus == 'Tidak Tersedia',
                    null,
                    Colors.orange,
                    (value) {
                      setState(() {
                        _selectedStatus = value ? 'Tidak Tersedia' : '';
                        _requestStatus = value ? 'Tidak Tersedia' : null;
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
                    _fetchLocations();
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
                    style: AppText.kaiseiRegular.copyWith(
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
              style: AppText.kaiseiRegular.copyWith(
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
