import 'package:flutter/material.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/constants/app_text.dart';
import 'package:smart_mob/widgets/common/app_top_bar.dart';
import 'package:smart_mob/core/api/api_client.dart';

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
  bool _isLoading = false;
  String _errorMessage = '';
  List<Map<String, dynamic>> _transactions = [];

  String _formatRupiah(dynamic value) {
    if (value == null) return '';
    num number;
    if (value is num) {
      number = value;
    } else {
      number = num.tryParse(value.toString()) ?? 0;
    }
    final s = number.toStringAsFixed(0);
    final buf = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buf.write(s[i]);
      count++;
      if (count == 3 && i != 0) {
        buf.write('.');
        count = 0;
      }
    }
    final reversed = buf.toString().split('').reversed.join();
    return 'Rp. $reversed';
  }

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final DateTime from = _startDate ?? DateTime.parse('2025-01-01T00:00:00');
    final DateTime to = _endDate ?? DateTime.parse('2025-12-31T23:59:59');

    try {
      final client = ApiClient.create();
      final response = await client.getDepositTransactions(
        page: 0,
        size: 1,
        sort: const ['string'],
        fromDate: from,
        toDate: to,
        search: _searchController.text.isEmpty ? null : _searchController.text,
        tipeTransaksi: _selectedTransactionType.isEmpty
            ? null
            : _selectedTransactionType,
        statusTransaksi: _selectedStatus.isEmpty ? null : _selectedStatus,
      );

      final Map<String, dynamic> body = (response.data is Map<String, dynamic>)
          ? response.data as Map<String, dynamic>
          : <String, dynamic>{};

      final Map<String, dynamic>? container =
          (body['data'] is Map<String, dynamic>)
          ? body['data'] as Map<String, dynamic>
          : null;

      List<dynamic> rawList = [];
      if (container != null && container['content'] is List) {
        rawList = container['content'] as List<dynamic>;
      } else if (body['content'] is List) {
        rawList = body['content'] as List<dynamic>;
      } else if (body['data'] is List) {
        rawList = body['data'] as List<dynamic>;
      }

      final mapped = rawList.map<Map<String, dynamic>>((item) {
        final m = item is Map<String, dynamic> ? item : <String, dynamic>{};

        final status =
            (m['transactionStatus'] ??
                    m['statusTransaksi'] ??
                    m['status'] ??
                    '')
                .toString();

        final txDate = (m['transactionDate'] ?? m['tanggalTransaksi'] ?? '')
            .toString();
        final txTime = (m['transactionTime'] ?? m['waktuTransaksi'] ?? '')
            .toString();

        String month = '';
        String formattedDate = '';
        if (txDate.isNotEmpty) {
          DateTime? dt;
          try {
            dt = DateTime.tryParse(txDate);
          } catch (_) {}
          if (dt != null) {
            const months = [
              'Januari',
              'Februari',
              'Maret',
              'April',
              'Mei',
              'Juni',
              'Juli',
              'Agustus',
              'September',
              'Oktober',
              'November',
              'Desember',
            ];
            month = months[dt.month - 1];
            formattedDate =
                '${dt.day.toString().padLeft(2, '0')} $month ${dt.year}' +
                (txTime.isNotEmpty ? ' $txTime' : '');
          } else {
            formattedDate = txDate + (txTime.isNotEmpty ? ' $txTime' : '');
          }
        }

        final company =
            (m['accountName'] ??
                    m['merchantName'] ??
                    m['company'] ??
                    m['namaPerusahaan'] ??
                    '')
                .toString();
        final dynamic rawAmount =
            (m['depositAmount'] ?? m['nominal'] ?? m['amount']);
        final amount = _formatRupiah(rawAmount);
        final type = (m['tipeTransaksi'] ?? m['type'] ?? 'Setoran').toString();

        return {
          'month': month,
          'status': status,
          'date': formattedDate,
          'company': company,
          'amount': amount,
          'type': type,
          'transactionNumber': (m['transactionNumber'] ?? '').toString(),
          'branch': (m['branch'] ?? '').toString(),
          'location': (m['location'] ?? '').toString(),
          'machine': (m['machine'] ?? '').toString(),
          'user': (m['user'] ?? '').toString(),
        };
      }).toList();

      setState(() {
        _transactions = mapped;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memuat data';
        _transactions = [];
      });
    }
  }

  // removed local filter; server-side filtering is used

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const AppTopBar(title: 'Riwayat Transaksi', showBack: true),
              Expanded(
                child: Column(
                  children: [
                    _buildSearchAndFilters(),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(20),
                        child: _buildTransactionList(_transactions),
                      ),
                    ),
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
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                hintText: 'Cari...',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: Colors.blue.shade300,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Material(
            color: Colors.white,
            elevation: 2,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _showFilterPopup,
              child: const SizedBox(
                width: 48,
                height: 48,
                child: Icon(Icons.filter_list, color: Colors.grey),
              ),
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
                        _selectedTransactionType = '';
                        _selectedPeriod = '';
                        _selectedStatus = '';
                        _startDate = null;
                        _endDate = null;
                      });
                      setModalState(() {});
                      Navigator.pop(context);
                      _fetchTransactions();
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
                'Type Transaction:',
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
                style: AppText.kaiseiRegular.copyWith(
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
                  Text('-', style: AppText.kaiseiRegular),
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
                    _fetchTransactions();
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
                    'Tampilkan hasil (${_transactions.length})',
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
          style: AppText.kaiseiRegular.copyWith(
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
              style: AppText.kaiseiRegular.copyWith(color: AppColors.textBlack),
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

  Widget _buildTransactionList(List<Map<String, dynamic>> transactions) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
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
          /// LEFT SIDE
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  month,
                  style: TextStyle(
                    color: AppColors.textBlack,
                    fontWeight: FontWeight.w700,
                    fontSize: 16, // ✅ smaller than before (18)
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      'Status ',
                      style: TextStyle(
                        color: AppColors.textLightGray,
                        fontSize: 12, // ✅ reduced from 13
                        height: 1.3,
                      ),
                    ),
                    Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12, // ✅ reduced from 13
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// RIGHT SIDE
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    color: AppColors.textLightGray,
                    fontSize: 11, // ✅ reduced from 12
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  company,
                  style: TextStyle(
                    color: AppColors.textLightGray,
                    fontSize: 11, // ✅ same, but balanced
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  amount,
                  style: TextStyle(
                    color: const Color(0xFF38A169),
                    fontWeight: FontWeight.w700,
                    fontSize: 16, // ✅ reduced from 18
                    height: 1.3,
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
