import 'package:flutter/material.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/constants/app_text.dart';
import 'package:url_launcher/url_launcher.dart';

class SetorTunaiLocationListScreen extends StatefulWidget {
  final List<Map<String, dynamic>> locations;

  const SetorTunaiLocationListScreen({super.key, required this.locations});

  @override
  State<SetorTunaiLocationListScreen> createState() =>
      _SetorTunaiLocationListScreenState();
}

class _SetorTunaiLocationListScreenState
    extends State<SetorTunaiLocationListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedType = '';
  String _selectedStatus = '';

  List<Map<String, dynamic>> get _filteredLocations {
    return widget.locations.where((location) {
      final name = location['name'].toString().toLowerCase();
      final address = location['address'].toString().toLowerCase();
      final type = location['type'].toString();
      final status = location['status'].toString();

      final matchesSearch =
          _searchQuery.isEmpty ||
          name.contains(_searchQuery.toLowerCase()) ||
          address.contains(_searchQuery.toLowerCase());

      final matchesType = _selectedType.isEmpty || type == _selectedType;
      final matchesStatus =
          _selectedStatus.isEmpty || status == _selectedStatus;

      return matchesSearch && matchesType && matchesStatus;
    }).toList();
  }

  Future<void> _openMaps({
    required double latitude,
    required double longitude,
    required String label,
  }) async {
    final Uri googleMaps = Uri.parse(
      'comgooglemaps://?q=${Uri.encodeComponent(label)}&center=$latitude,$longitude&zoom=16',
    );
    final Uri geoUri = Uri.parse(
      'geo:$latitude,$longitude?q=$latitude,$longitude(${Uri.encodeComponent(label)})',
    );
    final Uri googleWeb = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );

    if (await canLaunchUrl(googleMaps)) {
      await launchUrl(googleMaps);
      return;
    }
    if (await canLaunchUrl(geoUri)) {
      await launchUrl(geoUri);
      return;
    }
    await launchUrl(googleWeb, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Colors.black),
          ),
          centerTitle: true,
          title: Text(
            'List Lokasi Terdekat',
            style: AppText.kaiseiRegular.copyWith(
              color: AppColors.textBlack,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: _showFilterBottomSheet,
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.tune, color: Colors.grey[600], size: 20),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _filteredLocations.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = _filteredLocations[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: (item['iconColor'] as Color).withOpacity(
                              0.1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            color: item['iconColor'] as Color,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'].toString(),
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
                                item['address'].toString(),
                                style: TextStyle(
                                  color: AppColors.textGray,
                                  fontSize: 13,
                                  fontFamily: 'Roboto',
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: item['status'] == 'Buka'
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      item['status'],
                                      style: TextStyle(
                                        color: item['status'] == 'Buka'
                                            ? Colors.green[700]
                                            : Colors.red[700],
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    item['operatingHours'] ?? '',
                                    style: TextStyle(
                                      color: AppColors.textGray,
                                      fontSize: 10,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    item['distance'].toString(),
                                    style: TextStyle(
                                      color: AppColors.textGray,
                                      fontSize: 13,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              final double lat =
                                  (item['latitude'] as double?) ?? 0.0;
                              final double lng =
                                  (item['longitude'] as double?) ?? 0.0;
                              if (lat != 0.0 && lng != 0.0) {
                                _openMaps(
                                  latitude: lat,
                                  longitude: lng,
                                  label: item['name'].toString(),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.grey[200],
                              foregroundColor: AppColors.textBlack,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text('Navigate'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: SizedBox(
        height: 44,
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Cari lokasi...',
            hintStyle: TextStyle(color: Colors.grey[500]),
            prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
            suffixIcon: _searchQuery.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                    child: Icon(Icons.clear, color: Colors.grey[500]),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final types = widget.locations
        .map((e) => e['type'].toString())
        .toSet()
        .toList();
    final statuses = widget.locations
        .map((e) => e['status'].toString())
        .toSet()
        .toList();

    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildChip(
            'Semua',
            _selectedType.isEmpty && _selectedStatus.isEmpty,
            () {
              setState(() {
                _selectedType = '';
                _selectedStatus = '';
              });
            },
          ),
          ...types.map(
            (type) => _buildChip(type, _selectedType == type, () {
              setState(() {
                _selectedType = _selectedType == type ? '' : type;
                _selectedStatus = '';
              });
            }),
          ),
          ...statuses.map(
            (status) => _buildChip(status, _selectedStatus == status, () {
              setState(() {
                _selectedStatus = _selectedStatus == status ? '' : status;
                _selectedType = '';
              });
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        constraints: const BoxConstraints(minHeight: 34),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryRed : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryRed : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textGray,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) =>
            _buildFilterBottomSheet(setModalState),
      ),
    );
  }

  Widget _buildFilterBottomSheet(StateSetter setModalState) {
    final types = widget.locations
        .map((e) => e['type'].toString())
        .toSet()
        .toList();
    final statuses = widget.locations
        .map((e) => e['status'].toString())
        .toSet()
        .toList();

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
                    'Filter',
                    style: AppText.kaiseiRegular.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlack,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedType = '';
                        _selectedStatus = '';
                      });
                      setModalState(() {});
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
                children: types
                    .map(
                      (type) => _buildChip(type, _selectedType == type, () {
                        setState(() {
                          _selectedType = _selectedType == type ? '' : type;
                        });
                        setModalState(() {});
                      }),
                    )
                    .toList(),
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
                children: statuses
                    .map(
                      (status) =>
                          _buildChip(status, _selectedStatus == status, () {
                            setState(() {
                              _selectedStatus = _selectedStatus == status
                                  ? ''
                                  : status;
                            });
                            setModalState(() {});
                          }),
                    )
                    .toList(),
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
                    'Tampilkan (${_filteredLocations.length})',
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
}
