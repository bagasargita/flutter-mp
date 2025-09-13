import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../widgets/komisi/komisi_filter_modal.dart';
import '../../core/di/service_locator.dart';
import '../../features/home/presentation/bloc/transaction_data_bloc.dart';
import '../../features/home/presentation/bloc/transaction_data_event.dart';
import '../../features/home/presentation/bloc/transaction_data_state.dart';
import '../../features/home/data/models/transaction_item.dart';

class KomisiDetailScreen extends StatelessWidget {
  const KomisiDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      return BlocProvider(
        create: (context) => TransactionDataBloc(
          transactionDataService: ServiceLocator().transactionDataService,
        )..add(const TransactionDataRequested()),
        child: const _KomisiDetailScreenContent(),
      );
    } catch (e) {
      print('Error creating TransactionDataBloc: $e');
      return Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Gagal memuat layanan',
                style: AppText.kaiseiRegular.copyWith(
                  fontSize: 16,
                  color: AppColors.textGray,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                e.toString(),
                style: AppText.kaiseiRegular.copyWith(
                  fontSize: 14,
                  color: AppColors.textGray,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
  }
}

class _KomisiDetailScreenContent extends StatefulWidget {
  const _KomisiDetailScreenContent();

  @override
  State<_KomisiDetailScreenContent> createState() =>
      _KomisiDetailScreenContentState();
}

class _KomisiDetailScreenContentState
    extends State<_KomisiDetailScreenContent> {
  final ScrollController _scrollController = ScrollController();
  String? _transactionDateFrom;
  String? _transactionDateTo;
  String? _transactionNo;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<TransactionDataBloc>().add(
        TransactionDataLoadMore(
          transactionDateFrom: _transactionDateFrom,
          transactionDateTo: _transactionDateTo,
          transactionNo: _transactionNo,
        ),
      );
    }
  }

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
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton.icon(
                          onPressed: () => _showFilterModal(context),
                          icon: Icon(
                            Icons.tune,
                            size: 18,
                            color: _hasActiveFilters()
                                ? AppColors.primaryRed
                                : AppColors.textBlack,
                          ),
                          label: Text(
                            _hasActiveFilters() ? 'Filter (Active)' : 'Filter',
                            style: AppText.kaiseiRegular.copyWith(
                              color: _hasActiveFilters()
                                  ? AppColors.primaryRed
                                  : AppColors.textBlack,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: _hasActiveFilters()
                                  ? AppColors.primaryRed
                                  : Colors.grey[300]!,
                            ),
                            foregroundColor: _hasActiveFilters()
                                ? AppColors.primaryRed
                                : AppColors.textBlack,
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
                    ),
                    Expanded(
                      child:
                          BlocBuilder<
                            TransactionDataBloc,
                            TransactionDataState
                          >(
                            builder: (context, state) {
                              if (state is TransactionDataLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (state is TransactionDataFailure) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        size: 64,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Gagal memuat data transaksi',
                                        style: AppText.kaiseiRegular.copyWith(
                                          fontSize: 16,
                                          color: AppColors.textGray,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        state.message,
                                        style: AppText.kaiseiRegular.copyWith(
                                          fontSize: 14,
                                          color: AppColors.textGray,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () {
                                          context
                                              .read<TransactionDataBloc>()
                                              .add(
                                                const TransactionDataRequested(),
                                              );
                                        },
                                        child: const Text('Coba Lagi'),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              if (state is TransactionDataLoaded) {
                                return _buildTransactionList(state);
                              }

                              return const Center(
                                child: Text('Tidak ada data'),
                              );
                            },
                          ),
                    ),
                  ],
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

  Widget _buildTransactionList(TransactionDataLoaded state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          _buildHeaderRow(),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount:
                  state.transactions.length + (state.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= state.transactions.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return _buildTransactionRow(state.transactions[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        children: [
          _cell('Tanggal Transaksi', flex: 2, isHeader: true),
          _cell('Nama', flex: 2, isHeader: true),
          _cell('Jumlah', flex: 2, isHeader: true),
          _cell('Komisi', flex: 1, isHeader: true, alignEnd: true),
        ],
      ),
    );
  }

  Widget _buildTransactionRow(TransactionItem transaction) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            children: [
              _cell(_formatDate(transaction.transactionDate), flex: 2),
              _cell(transaction.name, flex: 2),
              _cell(
                'Rp${transaction.amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                flex: 2,
              ),
              Row(
                children: [
                  Text(
                    'Rp${transaction.commission.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
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
    final bloc = context.read<TransactionDataBloc>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      useSafeArea: true,
      builder: (context) => KomisiFilterModal(
        startDate: _transactionDateFrom != null
            ? DateTime.tryParse(_transactionDateFrom!)
            : null,
        endDate: _transactionDateTo != null
            ? DateTime.tryParse(_transactionDateTo!)
            : null,
        transactionNo: _transactionNo,
        onApplyFilter: (startDate, endDate, transactionNo) {
          setState(() {
            _transactionDateFrom = startDate?.toIso8601String();
            _transactionDateTo = endDate?.toIso8601String();
            _transactionNo = transactionNo;
          });

          bloc.add(
            TransactionDataFilterChanged(
              transactionDateFrom: _transactionDateFrom,
              transactionDateTo: _transactionDateTo,
              transactionNo: _transactionNo,
            ),
          );

          // Show appropriate message
          String filterMessage;
          if (startDate == null &&
              endDate == null &&
              (transactionNo == null || transactionNo.isEmpty)) {
            filterMessage = 'Filter berhasil dihapus';
          } else {
            filterMessage = 'Filter diterapkan: ';
            if (startDate != null || endDate != null) {
              filterMessage +=
                  '${startDate?.toString().split(' ')[0] ?? 'Semua'} - ${endDate?.toString().split(' ')[0] ?? 'Semua'}';
            }
            if (transactionNo != null && transactionNo.isNotEmpty) {
              if (startDate != null || endDate != null) {
                filterMessage += ', ';
              }
              filterMessage += 'No: $transactionNo';
            }
          }

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(filterMessage)));
        },
      ),
    );
  }

  bool _hasActiveFilters() {
    return _transactionDateFrom != null ||
        _transactionDateTo != null ||
        (_transactionNo != null && _transactionNo!.isNotEmpty);
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
