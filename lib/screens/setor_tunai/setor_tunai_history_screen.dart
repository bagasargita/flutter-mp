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

  String _selectedTransactionType = 'Setoran';
  String _selectedPeriod = '';
  String _selectedStatus = '';
  DateTime? _startDate;
  DateTime? _endDate;

  final List<Map<String, dynamic>> _transactions = [
    {
      'month': 'Juli',
      'status': 'Gagal',
      'date': '10 Juli 2025 14:23:44',
      'company': 'PT Warung Makmur Sejahtera',
      'amount': 'Rp -',
      'type': 'Setoran',
    },
    {
      'month': 'Juli',
      'status': 'Gagal',
      'date': '10 Juli 2025 14:23:44',
      'company': 'PT Warung Makmur Sejahtera',
      'amount': 'Rp -',
      'type': 'Setoran',
    },
    {
      'month': 'Juli',
      'status': 'Pending',
      'date': '09 Juli 2025 12:00:09',
      'company': 'PT Warung Makmur Sejahtera',
      'amount': 'Rp. 5.540.000',
      'type': 'Setoran',
    },
    {
      'month': 'Juni',
      'status': 'Berhasil',
      'date': '29 Juni 2025 21:03:55',
      'company': 'PT Warung Makmur Sejahtera',
      'amount': 'Rp. 3.250.000',
      'type': 'Setoran',
    },
    {
      'month': 'Mei',
      'status': 'Berhasil',
      'date': '30 Mei 2025 18:03:23',
      'company': 'PT Warung Makmur Sejahtera',
      'amount': 'Rp. 36.000.000',
      'type': 'Setoran',
    },
    {
      'month': 'Mei',
      'status': 'Successfully',
      'date': '30 Mei 2025 14:03:55',
      'company': 'PT Warung Makmur Sejahtera',
      'amount': 'Rp. 46.000.000',
      'type': 'Setoran',
    },
  ];

  List<Map<String, dynamic>> get _filteredTransactions {
    return _transactions.where((transaction) {
      final company = transaction['company']?.toString() ?? '';
      final amount = transaction['amount']?.toString() ?? '';
      final status = transaction['status']?.toString() ?? '';
      final type = transaction['type']?.toString() ?? '';

      bool matchesSearch =
          _searchController.text.isEmpty ||
          company.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          ) ||
          amount.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          status.toLowerCase().contains(_searchController.text.toLowerCase());

      bool matchesType =
          _selectedTransactionType.isEmpty || type == _selectedTransactionType;

      bool matchesStatus = _selectedStatus.isEmpty || status == _selectedStatus;

      return matchesSearch && matchesType && matchesStatus;
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
      child: Row(
        children: [
          Expanded(
            child: Container(
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
                      onChanged: (value) => setState(() {}),
                      decoration: const InputDecoration(
                        hintText: 'Cari',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() {});
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _showFilterPopup,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
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
              child: Icon(Icons.more_vert, color: Colors.grey[600], size: 24),
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
                        _selectedTransactionType = '';
                        _selectedPeriod = '';
                        _selectedStatus = '';
                        _startDate = null;
                        _endDate = null;
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
                'Type Transaction:',
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
                    'Setoran',
                    _selectedTransactionType == 'Setoran',
                    (value) {
                      setState(() {
                        _selectedTransactionType = value ? 'Setoran' : '';
                      });
                      setModalState(() {});
                    },
                  ),
                  _buildFilterChip(
                    'Tarik Tunai',
                    _selectedTransactionType == 'Tarik Tunai',
                    (value) {
                      setState(() {
                        _selectedTransactionType = value ? 'Tarik Tunai' : '';
                      });
                      setModalState(() {});
                    },
                  ),
                  _buildFilterChip(
                    'This month',
                    _selectedPeriod == 'This month',
                    (value) {
                      setState(() {
                        _selectedPeriod = value ? 'This month' : '';
                      });
                      setModalState(() {});
                    },
                  ),
                  _buildFilterChip(
                    'Previous month',
                    _selectedPeriod == 'Previous month',
                    (value) {
                      setState(() {
                        _selectedPeriod = value ? 'Previous month' : '';
                      });
                      setModalState(() {});
                    },
                  ),
                  _buildFilterChip(
                    'This year',
                    _selectedPeriod == 'This year',
                    (value) {
                      setState(() {
                        _selectedPeriod = value ? 'This year' : '';
                      });
                      setModalState(() {});
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Text(
                'Select period:',
                style: AppText.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlack,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildDateField(
                      '15 Sep 2023',
                      Icons.calendar_today,
                      () => _selectDate(true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('-', style: AppText.bodyMedium),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDateField(
                      '20 Sep 2023',
                      Icons.calendar_today,
                      () => _selectDate(false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Text(
                'Status:',
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
                  _buildFilterChip('Berhasil', _selectedStatus == 'Berhasil', (
                    value,
                  ) {
                    setState(() {
                      _selectedStatus = value ? 'Berhasil' : '';
                    });
                    setModalState(() {});
                  }),
                  _buildFilterChip('Pending', _selectedStatus == 'Pending', (
                    value,
                  ) {
                    setState(() {
                      _selectedStatus = value ? 'Pending' : '';
                    });
                    setModalState(() {});
                  }),
                  _buildFilterChip('Gagal', _selectedStatus == 'Gagal', (
                    value,
                  ) {
                    setState(() {
                      _selectedStatus = value ? 'Gagal' : '';
                    });
                    setModalState(() {});
                  }),
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
                    'Tampilkan hasil (${_filteredTransactions.length})',
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
    Function(bool) onChanged,
  ) {
    return GestureDetector(
      onTap: () => onChanged(!isSelected),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE6E6FA) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFE6E6FA) : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: AppText.bodySmall.copyWith(
            color: isSelected ? AppColors.textBlack : AppColors.textGray,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(String date, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[600], size: 16),
            const SizedBox(width: 8),
            Text(
              date,
              style: AppText.bodySmall.copyWith(color: AppColors.textBlack),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate(bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Widget _buildTransactionList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _filteredTransactions.length,
      itemBuilder: (context, index) {
        final transaction = _filteredTransactions[index];
        return _buildTransactionItem(transaction);
      },
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final month = transaction['month']?.toString() ?? '';
    final status = transaction['status']?.toString() ?? '';
    final date = transaction['date']?.toString() ?? '';
    final company = transaction['company']?.toString() ?? '';
    final amount = transaction['amount']?.toString() ?? '';

    Color statusColor;
    switch (status) {
      case 'Berhasil':
      case 'Successfully':
        statusColor = const Color(0xFF38A169);
        break;
      case 'Pending':
        statusColor = const Color(0xFFD69E2E);
        break;
      case 'Gagal':
        statusColor = const Color(0xFFE53E3E);
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  month,
                  style: TextStyle(
                    color: AppColors.textBlack,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    fontFamily: 'Roboto',
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Status ',
                      style: TextStyle(
                        color: AppColors.textLightGray,
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                        fontFamily: 'Roboto',
                        height: 1.2,
                      ),
                    ),
                    Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        fontFamily: 'Roboto',
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    color: AppColors.textLightGray,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Roboto',
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  company,
                  style: TextStyle(
                    color: AppColors.textLightGray,
                    fontWeight: FontWeight.normal,
                    fontSize: 11,
                    fontFamily: 'Roboto',
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  amount,
                  style: TextStyle(
                    color: const Color(0xFF38A169),
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    fontFamily: 'Roboto',
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
