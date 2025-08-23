import 'dart:async';
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
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HomeBloc>().add(const HomeDataRequested());
        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        if (_currentPage < 2) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
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
          const SizedBox(height: 24),
          Text(
            'Layanan',
            style: AppText.bodyMedium.copyWith(fontSize: 16),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 16),
          _buildServicesGrid(),
          const SizedBox(height: 20),
          _buildImageCarousel(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildImageCarousel() {
    final List<String> carouselImages = [
      'assets/images/Easy-Fast.png',
      'assets/images/Flexible-Transaction.png',
      'assets/images/MP-Logo.png',
    ];

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: carouselImages.length,
            itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    carouselImages[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image,
                          size: 64,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: carouselImages.asMap().entries.map((entry) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: entry.key == _currentPage
                    ? AppColors.primaryRed
                    : Colors.grey.withValues(alpha: 0.3),
              ),
            );
          }).toList(),
        ),
      ],
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
        'image': 'assets/images/NonTunai.png',
        'color': Colors.red,
      },
      {
        'name': 'Kirim Uang',
        'image': 'assets/images/KirimUang.png',
        'color': Colors.red,
      },
      {
        'name': 'Bayar Tagihan',
        'image': 'assets/images/RiwayatTransaksi.png',
        'color': Colors.red,
      },
      {
        'name': 'Kirim Barang',
        'image': 'assets/images/KirimBarang.png',
        'color': Colors.red,
      },
      {
        'name': 'Isi ulang',
        'image': 'assets/images/IsiUlang.png',
        'color': Colors.red,
      },
      {
        'name': 'Pinjaman',
        'image': 'assets/images/Pinjaman.png',
        'color': Colors.red,
      },
      {
        'name': 'Kirim Barang',
        'image': 'assets/images/KirimBarang2.png',
        'color': Colors.red,
      },
      {
        'name': 'Lainnya',
        'image': 'assets/images/IconLainnya.png',
        'color': Colors.red,
      },
    ];

    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
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
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
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
}
