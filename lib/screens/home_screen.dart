import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  // Cache for SVG content to prevent reloading
  final Map<String, String> _svgCache = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HomeBloc>().add(const HomeDataRequested());
        _startAutoScroll();
        _preloadCarouselImages();
      }
    });
  }

  void _preloadCarouselImages() {
    final carouselImages = [
      'assets/images/promo1.svg',
      'assets/images/ForgotPassword.png',
    ];

    for (final imagePath in carouselImages) {
      if (imagePath.endsWith('.svg')) {
        _loadSvgContent(imagePath);
      }
    }
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
          // Layanan Section Title
          Row(
            children: [
              Text(
                'Transaksi',
                style: AppText.bodyMedium.copyWith(fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ],
          ),

          const SizedBox(height: 16),
          // Use a separate widget that won't rebuild with carousel changes
          const ServicesSection(),
          const SizedBox(height: 20),
          // Promo Section Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Promo',
                style: AppText.bodyMedium.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Navigate to more promo details
                },
                child: Text(
                  'Selengkapnya',
                  style: AppText.bodyMedium.copyWith(
                    fontSize: 14,
                    color: AppColors.primaryRed,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildImageCarousel(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildImageCarousel() {
    final List<String> carouselImages = [
      'assets/images/promo1.svg',
      'assets/images/ForgotPassword.png',
    ];

    return RepaintBoundary(
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                // Only update the current page, don't rebuild entire screen
                if (mounted && _currentPage != index) {
                  setState(() {
                    _currentPage = index;
                  });
                }
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
                    child: _buildImageWidget(carouselImages[index]),
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
      ),
    );
  }

  Widget _buildImageWidget(String imagePath) {
    if (imagePath.endsWith('.svg')) {
      // Check if content is already cached
      if (_svgCache.containsKey(imagePath)) {
        final svgContent = _svgCache[imagePath]!;
        if (svgContent.contains('data:image/png;base64,')) {
          return RepaintBoundary(child: _buildBase64Image(svgContent));
        } else {
          return RepaintBoundary(
            child: SvgPicture.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print('SVG Error for $imagePath: $error');
                return Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, size: 64, color: Colors.grey),
                );
              },
            ),
          );
        }
      }

      // If not cached, use FutureBuilder
      return FutureBuilder<String>(
        future: _loadSvgContent(imagePath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.grey[200],
              child: const Icon(Icons.image, size: 64, color: Colors.grey),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Container(
              color: Colors.grey[200],
              child: const Icon(Icons.image, size: 64, color: Colors.grey),
            );
          }

          final svgContent = snapshot.data!;
          if (svgContent.contains('data:image/png;base64,')) {
            return RepaintBoundary(child: _buildBase64Image(svgContent));
          } else {
            return RepaintBoundary(
              child: SvgPicture.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  print('SVG Error for $imagePath: $error');
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
            );
          }
        },
      );
    } else {
      return RepaintBoundary(
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: const Icon(Icons.image, size: 64, color: Colors.grey),
            );
          },
        ),
      );
    }
  }

  Future<String> _loadSvgContent(String imagePath) async {
    // Check cache first
    if (_svgCache.containsKey(imagePath)) {
      return _svgCache[imagePath]!;
    }

    try {
      final assetBundle = DefaultAssetBundle.of(context);
      final content = await assetBundle.loadString(imagePath);

      // Cache the content
      _svgCache[imagePath] = content;

      return content;
    } catch (e) {
      print('Error loading SVG content: $e');
      return '';
    }
  }

  Widget _buildBase64Image(String svgContent) {
    try {
      final base64Match = RegExp(
        r'data:image/png;base64,([^"]+)',
      ).firstMatch(svgContent);
      if (base64Match != null) {
        final base64Data = base64Match.group(1);
        if (base64Data != null) {
          return Image.memory(
            base64Decode(base64Data),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print('Base64 image error: $error');
              return Container(
                color: Colors.grey[200],
                child: const Icon(Icons.image, size: 64, color: Colors.grey),
              );
            },
          );
        }
      }
    } catch (e) {
      print('Error parsing base64 image: $e');
    }

    return Container(
      color: Colors.grey[200],
      child: const Icon(Icons.image, size: 64, color: Colors.grey),
    );
  }
}

// Separate widget for services that won't rebuild with carousel changes
class ServicesSection extends StatefulWidget {
  const ServicesSection({super.key});

  @override
  State<ServicesSection> createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<ServicesSection>
    with AutomaticKeepAliveClientMixin {
  // Local cache for this section
  final Map<String, String> _svgCache = {};

  // Keep this widget alive even when parent rebuilds
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _preloadServiceIcons();
  }

  void _preloadServiceIcons() {
    final serviceImages = [
      'assets/images/SetorTunai.svg',
      'assets/images/NonTunai.svg',
      'assets/images/KirimUang.svg',
      'assets/images/BayarTagihan.svg',
      'assets/images/KirimBarang.svg',
      'assets/images/IsiUlang.svg',
      'assets/images/Pinjaman.svg',
      'assets/images/KirimBarang2.svg',
      'assets/images/Lainnya.svg',
    ];

    for (final imagePath in serviceImages) {
      _loadSvgContent(imagePath);
    }
  }

  Future<String> _loadSvgContent(String imagePath) async {
    if (_svgCache.containsKey(imagePath)) {
      return _svgCache[imagePath]!;
    }

    try {
      final assetBundle = DefaultAssetBundle.of(context);
      final content = await assetBundle.loadString(imagePath);
      _svgCache[imagePath] = content;
      return content;
    } catch (e) {
      print('Error loading SVG content: $e');
      return '';
    }
  }

  Widget _buildBase64Image(String svgContent) {
    try {
      final base64Match = RegExp(
        r'data:image/png;base64,([^"]+)',
      ).firstMatch(svgContent);
      if (base64Match != null) {
        final base64Data = base64Match.group(1);
        if (base64Data != null) {
          return Image.memory(
            base64Decode(base64Data),
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              print('Base64 image error: $error');
              return Container(
                color: Colors.grey[200],
                child: const Icon(Icons.image, size: 20, color: Colors.grey),
              );
            },
          );
        }
      }
    } catch (e) {
      print('Error parsing base64 image: $e');
    }

    return Container(
      color: Colors.grey[200],
      child: const Icon(Icons.image, size: 20, color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Call super.build to ensure keepAlive is true

    return RepaintBoundary(child: _buildServicesContent());
  }

  Widget _buildServicesContent() {
    final services = [
      {
        'name': 'Setor Tunai',
        'image': 'assets/images/SetorTunai.svg',
        'color': Colors.red,
      },
      {
        'name': 'Non Tunai',
        'image': 'assets/images/NonTunai.svg',
        'color': Colors.red,
      },
      {
        'name': 'Kirim Uang',
        'image': 'assets/images/KirimUang.svg',
        'color': Colors.red,
      },
      {
        'name': 'Bayar Tagihan',
        'image': 'assets/images/BayarTagihan.svg',
        'color': Colors.red,
      },
      {
        'name': 'Kirim Barang',
        'image': 'assets/images/KirimBarang.svg',
        'color': Colors.red,
      },
      {
        'name': 'Isi ulang',
        'image': 'assets/images/IsiUlang.svg',
        'color': Colors.red,
      },
      {
        'name': 'Pinjaman',
        'image': 'assets/images/Pinjaman.svg',
        'color': Colors.red,
      },
      {
        'name': 'Kirim Barang',
        'image': 'assets/images/KirimBarang2.svg',
        'color': Colors.red,
      },
      {
        'name': 'Lainnya',
        'image': 'assets/images/Lainnya.svg',
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
    return RepaintBoundary(
      child: GestureDetector(
        onTap: () {
          if (service['name'] == 'Lainnya') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AllServicesScreen(),
              ),
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: _buildServiceIcon(service['image'], service['color']),
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
      ),
    );
  }

  Widget _buildServiceIcon(String imagePath, Color color) {
    // Check if content is already cached
    if (_svgCache.containsKey(imagePath)) {
      final svgContent = _svgCache[imagePath]!;
      if (svgContent.contains('data:image/png;base64,')) {
        return RepaintBoundary(child: _buildBase64Image(svgContent));
      } else {
        return RepaintBoundary(
          child: SvgPicture.asset(
            imagePath,
            width: 40,
            height: 40,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              print('Service SVG Error for $imagePath: $error');
              return Container(
                width: 40,
                height: 40,
                color: Colors.grey[200],
                child: Icon(Icons.image, color: color, size: 20),
              );
            },
          ),
        );
      }
    }

    // If not cached, use FutureBuilder
    return FutureBuilder<String>(
      future: _loadSvgContent(imagePath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: 40,
            height: 40,
            color: Colors.grey[200],
            child: Icon(Icons.image, color: color, size: 20),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Container(
            width: 40,
            height: 40,
            color: Colors.grey[200],
            child: Icon(Icons.image, color: color, size: 20),
          );
        }

        final svgContent = snapshot.data!;
        if (svgContent.contains('data:image/png;base64,')) {
          return RepaintBoundary(child: _buildBase64Image(svgContent));
        } else {
          return RepaintBoundary(
            child: SvgPicture.asset(
              imagePath,
              width: 40,
              height: 40,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                print('Service SVG Error for $imagePath: $error');
                return Container(
                  width: 40,
                  height: 40,
                  color: Colors.grey[200],
                  child: Icon(Icons.image, color: color, size: 20),
                );
              },
            ),
          );
        }
      },
    );
  }
}
