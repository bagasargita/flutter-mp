import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text.dart';
import 'komisi_detail_screen.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/home/data/models/dashboard_response.dart';
import '../../core/di/service_locator.dart';

class KomisiScreen extends StatelessWidget {
  const KomisiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HomeBloc(dashboardService: ServiceLocator().dashboardService),
      child: const _KomisiScreenContent(),
    );
  }
}

class _KomisiScreenContent extends StatefulWidget {
  const _KomisiScreenContent();

  @override
  State<_KomisiScreenContent> createState() => _KomisiScreenContentState();
}

class _KomisiScreenContentState extends State<_KomisiScreenContent> {
  @override
  void initState() {
    super.initState();
    // Trigger data fetch when first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HomeBloc>().add(const HomeDataRequested());
      }
    });
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
                title: 'Komisi',
                showBack: Navigator.of(context).canPop(),
              ),
              Expanded(
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is HomeFailure) {
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
                              'Gagal memuat data',
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
                                context.read<HomeBloc>().add(
                                  const HomeDataRequested(),
                                );
                              },
                              child: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is HomeLoaded &&
                        state.dashboardResponse != null) {
                      return _buildDashboardContent(state.dashboardResponse!);
                    }

                    return const Center(child: Text('Tidak ada data'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardContent(DashboardResponse dashboardResponse) {
    final cards = dashboardResponse.data.cards;
    print('KomisiScreen: Building dashboard with ${cards.length} cards');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: cards.map((card) {
              return _StatCard(
                title: card.title,
                value: card.formattedValue,
                trend: card.trend,
                trendDirection: card.trendDirection,
                fullWidth: card.id == 5,
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Detail Komisi',
                style: AppText.kaiseiRegular.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textBlack,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const KomisiDetailScreen(),
                    ),
                  );
                },
                child: Text(
                  'Selengkapnya',
                  style: AppText.kaiseiRegular.copyWith(
                    fontSize: 14,
                    color: AppColors.primaryRed,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mengunduh laporan...')),
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
                      const SnackBar(content: Text('Membagikan laporan...')),
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
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final bool fullWidth;
  final double? trend;
  final String? trendDirection;

  const _StatCard({
    required this.title,
    required this.value,
    this.fullWidth = false,
    this.trend,
    this.trendDirection,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cardWidth = fullWidth ? width - 40 : (width - 56) / 2;
    return SizedBox(
      width: cardWidth,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppText.kaiseiRegular.copyWith(
                fontSize: 12,
                color: AppColors.textGray,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: AppText.kaiseiRegular.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textBlack,
              ),
            ),
            if (trend != null && trendDirection != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    trendDirection == 'up'
                        ? Icons.trending_up
                        : Icons.trending_down,
                    size: 16,
                    color: trendDirection == 'up' ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${trend!.toStringAsFixed(1)}%',
                    style: AppText.kaiseiRegular.copyWith(
                      fontSize: 12,
                      color: trendDirection == 'up' ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
