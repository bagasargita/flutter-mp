import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/search/search_top_bar.dart';
import '../../widgets/search/search_bar.dart';
import '../../widgets/search/map_section.dart';
import 'transaction_detail_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        body: SafeArea(
          child: Column(
            children: [
              const AppTopBar(title: 'Search'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildSearchCard(
                        context,
                        'Mesin',
                        'Cari lokasi Mesin CDM',
                        Icons.account_balance,
                        Colors.blue,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchMachineScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSearchCard(
                        context,
                        'Warung / Grosir',
                        'Cari warung atau grosir',
                        Icons.store,
                        Colors.green,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchShopScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSearchCard(
                        context,
                        'Riwayat Transaksi',
                        'Cari Riwayat Transaksi',
                        Icons.history,
                        Colors.orange,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const SearchTransactionHistoryScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                    textScaler: TextScaler.linear(1.0),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textGray,
                    ),
                    textScaler: TextScaler.linear(1.0),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textGray,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class SearchMachineScreen extends StatelessWidget {
  const SearchMachineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const locations = <Location>[
      Location(name: 'Grosir Pondok Pinang', distance: '56 m'),
      Location(name: 'WSMM Pondok Indah', distance: '1.2 km'),
      Location(name: 'Warung Madura Deplu', distance: '5.3 km'),
      Location(name: 'LPI Kartika Utama', distance: '7km'),
      Location(name: 'Grosir Ciputat', distance: '20m'),
    ];
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        body: SafeArea(
          child: Column(
            children: [
              SearchTopBar(
                title: 'Search',
                onBackPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const MapSection(
                        pins: [
                          MapPin(
                            top: 50,
                            left: 50,
                            size: 12,
                            color: AppColors.primaryRed,
                          ),
                          MapPin(
                            top: 80,
                            left: 200,
                            size: 8,
                            color: Colors.blue,
                          ),
                          MapPin(
                            top: 140,
                            left: 120,
                            size: 8,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const SearchInputBar(),
                      const SizedBox(height: 16),
                      const Expanded(
                        child: LocationList(
                          items: locations,
                          dotColor: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchShopScreen extends StatelessWidget {
  const SearchShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const locations = <Location>[
      Location(name: 'Grosir Pondok Pinang 1', distance: '56 m'),
      Location(name: 'Grosir Pondok Pinang 2', distance: '1.2 km'),
      Location(name: 'Warung Madura Deplu 1', distance: '5.3 km'),
      Location(name: 'Warung Madura Deplu 2', distance: '7km'),
      Location(name: 'Grosir Ciputat', distance: '20m'),
    ];
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        body: SafeArea(
          child: Column(
            children: [
              SearchTopBar(
                title: 'Search',
                onBackPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const MapSection(
                        pins: [
                          MapPin(
                            top: 50,
                            left: 50,
                            size: 8,
                            color: AppColors.primaryRed,
                          ),
                          MapPin(
                            top: 80,
                            left: 200,
                            size: 8,
                            color: AppColors.primaryRed,
                          ),
                          MapPin(
                            top: 140,
                            left: 120,
                            size: 8,
                            color: AppColors.primaryRed,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const SearchInputBar(),
                      const SizedBox(height: 16),
                      const Expanded(
                        child: LocationList(
                          items: locations,
                          dotColor: AppColors.primaryRed,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchTransactionHistoryScreen extends StatefulWidget {
  const SearchTransactionHistoryScreen({super.key});

  @override
  State<SearchTransactionHistoryScreen> createState() =>
      _SearchTransactionHistoryScreenState();
}

class _SearchTransactionHistoryScreenState
    extends State<SearchTransactionHistoryScreen> {
  String _selectedFilter = 'Setoran';

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        body: SafeArea(
          child: Column(
            children: [
              SearchTopBar(
                title: 'Search',
                onBackPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SearchInputBar(),
                      const SizedBox(height: 16),
                      _buildFilterButtons(),
                      const SizedBox(height: 16),
                      Expanded(child: _buildTransactionList()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButtons() {
    final filters = ['Setoran', 'Pulsa', 'Listrik PLN'];

    return Row(
      children: filters.map((filter) {
        final isSelected = _selectedFilter == filter;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected
                    ? AppColors.primaryRed
                    : Colors.grey[200],
                foregroundColor: isSelected
                    ? Colors.white
                    : AppColors.textBlack,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                textScaler: TextScaler.linear(1.0),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTransactionList() {
    final transactions = [
      {
        'month': 'Juli',
        'transactions': <Map<String, String>>[
          {
            'status': 'Gagal',
            'date': '10 Juli 2023 14:23:44',
            'amount': 'Rp. 13.800.000',
          },
          {
            'status': 'Pending',
            'date': '05 Juli 2023 13:09:09',
            'amount': 'Rp. 5.540.000',
          },
        ],
      },
      {
        'month': 'Juni',
        'transactions': <Map<String, String>>[
          {
            'status': 'Successfully',
            'date': '29 Juni 2023 10:02:55',
            'amount': 'Rp. 3.310.000',
          },
        ],
      },
      {
        'month': 'Mei',
        'transactions': <Map<String, String>>[
          {
            'status': 'Successfully',
            'date': '30 Mei 2023 10:20:20',
            'amount': 'Rp. 36.000.000',
          },
          {
            'status': 'Successfully',
            'date': '20 Mei 2023 14:33:33',
            'amount': 'Rp. 43.850.000',
          },
        ],
      },
    ];

    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final monthData = transactions[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                monthData['month'] as String,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
                textScaler: TextScaler.linear(1.0),
              ),
            ),
            ...(monthData['transactions'] as List<Map<String, String>>).map(
              (transaction) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TransactionDetailScreen(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _getStatusColor(transaction['status']!),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transaction['status']!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: _getStatusColor(transaction['status']!),
                              ),
                              textScaler: TextScaler.linear(1.0),
                            ),
                            Text(
                              transaction['date']!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textGray,
                              ),
                              textScaler: TextScaler.linear(1.0),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        transaction['amount']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                        textScaler: TextScaler.linear(1.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Successfully':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Gagal':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class Location {
  final String name;
  final String distance;
  const Location({required this.name, required this.distance});
}

class LocationList extends StatelessWidget {
  final List<Location> items;
  final Color dotColor;
  const LocationList({super.key, required this.items, required this.dotColor});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textBlack,
                      ),
                      textScaler: const TextScaler.linear(1.0),
                    ),
                    Text(
                      item.distance,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textGray,
                      ),
                      textScaler: const TextScaler.linear(1.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
