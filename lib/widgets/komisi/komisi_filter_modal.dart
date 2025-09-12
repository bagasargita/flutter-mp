import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text.dart';

class KomisiFilterModal extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime?, DateTime?) onApplyFilter;

  const KomisiFilterModal({
    super.key,
    this.startDate,
    this.endDate,
    required this.onApplyFilter,
  });

  @override
  State<KomisiFilterModal> createState() => _KomisiFilterModalState();
}

class _KomisiFilterModalState extends State<KomisiFilterModal> {
  late DateTime? _startDate;
  late DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select period',
                    style: AppText.kaiseiRegular.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlack,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateField(
                          'Start Date',
                          _startDate,
                          (date) => setState(() => _startDate = date),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDateField(
                          'End Date',
                          _endDate,
                          (date) => setState(() => _endDate = date),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Filters',
            style: AppText.kaiseiRegular.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _startDate = null;
                _endDate = null;
              });
            },
            child: Text(
              'Clear',
              style: AppText.kaiseiRegular.copyWith(
                fontSize: 16,
                color: AppColors.primaryRed,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(
    String label,
    DateTime? date,
    Function(DateTime?) onDateSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppText.kaiseiRegular.copyWith(
            fontSize: 14,
            color: AppColors.textGray,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectDate(context, onDateSelected),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    date != null
                        ? '${date.day} ${_getMonthName(date.month)} ${date.year}'
                        : 'Select date',
                    style: AppText.kaiseiRegular.copyWith(
                      fontSize: 14,
                      color: date != null
                          ? AppColors.textBlack
                          : Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    final hasSelection = _startDate != null || _endDate != null;
    final resultCount = _calculateResultCount();

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: hasSelection
                  ? () {
                      widget.onApplyFilter(_startDate, _endDate);
                      Navigator.pop(context);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: hasSelection
                    ? AppColors.primaryRed
                    : Colors.grey[300],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                hasSelection
                    ? 'Tampilkan hasil ($resultCount)'
                    : 'Pilih periode terlebih dahulu',
                style: AppText.kaiseiRegular.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    Function(DateTime?) onDateSelected,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryRed,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textBlack,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  int _calculateResultCount() {
    // Mock calculation - in real app, this would be based on actual data
    if (_startDate == null && _endDate == null) return 0;
    return 3261; // Mock result count
  }
}
