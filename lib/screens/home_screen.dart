import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/app_colors.dart';
import '../constants/app_text.dart';
import '../features/home/presentation/bloc/home_bloc.dart';
import 'all_services_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HomeBloc>().add(const HomeDataRequested());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.backgroundWhite,
          body: SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(child: _buildMainContent()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: const AssetImage('assets/images/profile.png'),
                onBackgroundImageError: (exception, stackTrace) {
                  // Handle error if image fails to load
                },
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryRed,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'SMARTMobs',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
            child: Stack(
              children: [
                const Icon(
                  Icons.notifications,
                  size: 24,
                  color: AppColors.textBlack,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryRed,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildTopImage(),
          const SizedBox(height: 24),
          _buildServicesGrid(),
          const SizedBox(height: 24),
          _buildBottomImage(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTopImage() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'assets/images/Easy-Fast.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: const Icon(Icons.image, size: 64, color: Colors.grey),
            );
          },
        ),
      ),
    );
  }

  Widget _buildServicesGrid() {
    final services = [
      {
        'name': 'Setor Tunai',
        'image': 'assets/images/SetorTunai.png',
        'color': Colors.red,
      },
      {
        'name': 'Non Tunai',
        'image': 'assets/images/Flexible-Transaction.png',
        'color': Colors.red,
      },
      {
        'name': 'Kirim Uang',
        'image': 'assets/images/KirimUang.png',
        'color': Colors.red,
      },
      {
        'name': 'Bayar Tagihan',
        'image': 'assets/images/ListrikPln.png',
        'color': Colors.red,
      },
      {
        'name': 'Kirim Barang',
        'image': 'assets/images/WarungGrosir.png',
        'color': Colors.red,
      },
      {
        'name': 'Isi ulang',
        'image': 'assets/images/Easy-Fast.png',
        'color': Colors.red,
      },
      {
        'name': 'Bayar Tagihan',
        'image': 'assets/images/RiwayatTransaksi.png',
        'color': Colors.red,
      },
      {
        'name': 'Kirim Barang',
        'image': 'assets/images/Savings-Money.png',
        'color': Colors.red,
      },
      {
        'name': 'Lainnya',
        'image': 'assets/images/IconLainnya.png',
        'color': Colors.red,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return _buildServiceItem(service);
      },
    );
  }

  Widget _buildServiceItem(Map<String, dynamic> service) {
    return GestureDetector(
      onTap: () {
        if (service['name'] == 'Lainnya') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AllServicesScreen()),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(243, 239, 239, 1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 53,
              height: 53,
              decoration: BoxDecoration(
                color: service['color'].withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  service['image'],
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.image, color: service['color'], size: 20);
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              service['name'],
              style: AppText.bodyMedium.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomImage() {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'assets/images/Flexible-Transaction.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: const Icon(Icons.image, size: 64, color: Colors.grey),
            );
          },
        ),
      ),
    );
  }
}
