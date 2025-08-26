import 'package:flutter/material.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/constants/app_text.dart';
import 'package:smart_mob/widgets/common/app_top_bar.dart';

class SetorTunaiHistoryScreen extends StatefulWidget {
  const SetorTunaiHistoryScreen({super.key});

  @override
  State<SetorTunaiHistoryScreen> createState() =>
      _SetorTunaiHistoryScreenState();
}

class _SetorTunaiHistoryScreenState extends State<SetorTunaiHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Setoran';

  final List<Map<String, dynamic>> _transactions = [
    {
      'date': '10 Juli 2025 14:23:44',
      'status': 'Status Gagal',
      'amount': 'Rp. 104.000.000',
      'type': 'Setoran',
    },
    {
      'date': '8 Juli 2025 09:15:30',
      'status': 'Status Pending',
      'amount': 'Rp. 5.940.000',
      'type': 'Setoran',
    },
    {
      'date': '5 Juli 2025 16:45:12',
      'status': 'Status Successfully',
      'amount': 'Rp. 2.250.000',
      'type': 'Setoran',
    },
    {
      'date': '2 Juli 2025 11:30:00',
      'status': 'Status Successfully',
      'amount': 'Rp. 36.000.000',
      'type': 'Setoran',
    },
    {
      'date': '30 Juni 2025 13:20:15',
      'status': 'Status Successfully',
      'amount': 'Rp. 46.000.000',
      'type': 'Setoran',
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
              const AppTopBar(title: 'Riwayat Transaksi', showBack: true),
              Expanded(
                child: Column(
                  children: [
                    _buildSearchAndFilters(),
                    Expanded(child: _buildTransactionList()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.grey[300]!),
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
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildFilterButton('Setoran', 'Setoran'),
              const SizedBox(width: 12),
              _buildFilterButton('Pulsa', 'Pulsa'),
              const SizedBox(width: 12),
              _buildFilterButton('Listrik PLN', 'Listrik PLN'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text, String value) {
    final isSelected = _selectedFilter == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryRed : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.primaryRed : Colors.grey[300]!,
            ),
          ),
          child: Text(
            text,
            style: AppText.bodySmall.copyWith(
              color: isSelected ? Colors.white : AppColors.textGray,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    final filteredTransactions = _transactions.where((transaction) {
      if (_selectedFilter == 'Setoran') {
        return transaction['type'] == 'Setoran';
      }
      return true;
    }).toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: filteredTransactions.length,
      itemBuilder: (context, index) {
        final transaction = filteredTransactions[index];
        return _buildTransactionItem(transaction);
      },
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    Color statusColor;
    IconData statusIcon;

    switch (transaction['status']) {
      case 'Status Successfully':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'Status Pending':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      case 'Status Gagal':
        statusColor = Colors.red;
        statusIcon = Icons.error;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.info;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, color: statusColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['date'],
                  style: AppText.bodyMedium.copyWith(
                    color: AppColors.textBlack,
                    fontWeight: FontWeight.w600,
                  ),
                  textScaler: TextScaler.linear(1.0),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction['status'],
                  style: AppText.bodySmall.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                  textScaler: TextScaler.linear(1.0),
                ),
              ],
            ),
          ),
          Text(
            transaction['amount'],
            style: AppText.bodyMedium.copyWith(
              color: AppColors.textBlack,
              fontWeight: FontWeight.w600,
            ),
            textScaler: TextScaler.linear(1.0),
          ),
        ],
      ),
    );
  }
}
