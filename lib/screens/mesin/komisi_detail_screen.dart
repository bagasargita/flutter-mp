import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/komisi/komisi_filter_modal.dart';

class KomisiDetailScreen extends StatelessWidget {
  const KomisiDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: const TextScaler.linear(1.0)),
        child: SafeArea(
          child: Column(
            children: [
              AppTopBar(
                title: 'Detail Komisi',
                showBack: Navigator.of(context).canPop(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton.icon(
                          onPressed: () => _showFilterModal(context),
                          icon: const Icon(
                            Icons.tune,
                            size: 18,
                            color: AppColors.textBlack,
                          ),
                          label: const Text('Filter'),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey[300]!),
                            foregroundColor: AppColors.textBlack,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          children: [
                            _buildHeaderRow(),
                            const Divider(height: 1),
                            ..._mockRows.map((e) => _buildDataRow(e)).toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  border: Border(top: BorderSide(color: Colors.grey[300]!)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Mengunduh laporan...'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.textBlack,
                          side: BorderSide(color: Colors.grey[300]!),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Download'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Membagikan laporan...'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF7A7A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Share'),
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

  Widget _buildHeaderRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        children: [
          _cell('Tanggal Transaksi', flex: 2, isHeader: true),
          _cell('Jumlah setoran', flex: 2, isHeader: true),
          _cell('Komisi', flex: 1, isHeader: true, alignEnd: true),
        ],
      ),
    );
  }

  Widget _buildDataRow(Map<String, String> row) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            children: [
              _cell(row['tanggal']!, flex: 2),
              _cell(row['setoran']!, flex: 2),
              Row(
                children: [
                  Text(
                    row['komisi']!,
                    style: AppText.kaiseiRegular.copyWith(
                      fontSize: 12,
                      color: AppColors.textBlack,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.remove_red_eye_outlined,
                    size: 18,
                    color: AppColors.textGray,
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }

  Widget _cell(
    String text, {
    int flex = 1,
    bool isHeader = false,
    bool alignEnd = false,
  }) {
    return Expanded(
      flex: flex,
      child: Align(
        alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
          text,
          style: AppText.kaiseiRegular.copyWith(
            fontSize: isHeader ? 12 : 12,
            fontWeight: isHeader ? FontWeight.w600 : FontWeight.w400,
            color: AppColors.textBlack,
          ),
        ),
      ),
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      builder: (context) => KomisiFilterModal(
        onApplyFilter: (startDate, endDate) {
          // TODO: Apply filter logic here
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Filter applied: ${startDate?.toString().split(' ')[0] ?? 'No start'} to ${endDate?.toString().split(' ')[0] ?? 'No end'}',
              ),
            ),
          );
        },
      ),
    );
  }
}

final List<Map<String, String>> _mockRows = [
  {'tanggal': '10/09/2025', 'setoran': 'Rp 1.000.000', 'komisi': 'Rp 5.000'},
  {'tanggal': '09/09/2025', 'setoran': 'Rp 2.500.000', 'komisi': 'Rp 12.500'},
  {'tanggal': '08/09/2025', 'setoran': 'Rp 750.000', 'komisi': 'Rp 3.750'},
  {'tanggal': '07/09/2025', 'setoran': 'Rp 3.200.000', 'komisi': 'Rp 16.000'},
];
