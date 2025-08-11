import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/app_colors.dart';
import '../constants/app_text.dart';
import '../features/home/presentation/bloc/home_bloc.dart';
import 'all_services_screen.dart';
import 'setor_tunai/setor_tunai_screen.dart';
import '../widgets/common/app_top_bar.dart';

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
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.backgroundWhite,
            body: SafeArea(
              child: Column(
                children: [
                  const AppTopBar(
                    title: 'Merah Putih',
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/images/profile.png'),
                    ),
                  ),
                  Expanded(child: _buildMainContent()),
                ],
              ),
            ),
          );
        },
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
        } else if (service['name'] == 'Setor Tunai') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SetorTunaiScreen()),
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
              textScaler: TextScaler.linear(1.0),
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
