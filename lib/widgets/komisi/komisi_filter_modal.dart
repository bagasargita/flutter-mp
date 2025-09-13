import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text.dart';

class KomisiFilterModal extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? transactionNo;
  final Function(DateTime?, DateTime?, String?) onApplyFilter;

  const KomisiFilterModal({
    super.key,
    this.startDate,
    this.endDate,
    this.transactionNo,
    required this.onApplyFilter,
  });

  @override
  State<KomisiFilterModal> createState() => _KomisiFilterModalState();
}

class _KomisiFilterModalState extends State<KomisiFilterModal> {
  late DateTime? _startDate;
  late DateTime? _endDate;
  late TextEditingController _transactionNoController;

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
    _transactionNoController = TextEditingController(
      text: widget.transactionNo ?? '',
    );
  }

  @override
  void dispose() {
    _transactionNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final modalHeight = screenHeight * 0.6;

    return Container(
      height: modalHeight,
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.8,
        minHeight: 400,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Filter Options',
                    style: AppText.kaiseiRegular.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlack,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Transaction Number Field
                  Text(
                    'Transaction Number',
                    style: AppText.kaiseiRegular.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textBlack,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTransactionNoField(),
                  const SizedBox(height: 16),

                  // Date Range Fields
                  Text(
                    'Date Range',
                    style: AppText.kaiseiRegular.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textBlack,
                    ),
                  ),
                  const SizedBox(height: 8),
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
                  const SizedBox(height: 16),
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
                _transactionNoController.clear();
              });

              // Apply the cleared filter immediately
              widget.onApplyFilter(null, null, null);
              Navigator.pop(context);
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

  Widget _buildTransactionNoField() {
    return TextField(
      controller: _transactionNoController,
      decoration: InputDecoration(
        hintText: 'Enter transaction number',
        hintStyle: AppText.kaiseiRegular.copyWith(
          fontSize: 14,
          color: Colors.grey[600],
        ),
        prefixIcon: Icon(Icons.receipt_long, size: 18, color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryRed),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
      style: AppText.kaiseiRegular.copyWith(
        fontSize: 14,
        color: AppColors.textBlack,
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
    final hasSelection =
        _startDate != null ||
        _endDate != null ||
        _transactionNoController.text.isNotEmpty;

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
                      widget.onApplyFilter(
                        _startDate,
                        _endDate,
                        _transactionNoController.text.isNotEmpty
                            ? _transactionNoController.text.trim()
                            : null,
                      );
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
                hasSelection ? 'Apply Filter' : 'Pilih filter terlebih dahulu',
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
}
