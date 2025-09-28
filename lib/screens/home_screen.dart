import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_colors.dart';
import '../constants/app_text.dart';
import '../features/app/presentation/bloc/app_bloc.dart';
import 'setor_tunai/setor_tunai_screen.dart';
import 'mesin/komisi_screen.dart';
// import 'mesin/riwayat_screen.dart';
import 'mesin/faq_screen.dart';
import '../widgets/common/app_top_bar.dart';
import 'setor_tunai/setor_tunai_help_screen.dart';
import 'non_mesin/qr_scanner_screen.dart';
import 'setor_tunai/setor_tunai_history_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userRoleMobile;
  final String userEmail;
  final String userName;
  final String selectedRole;
  const HomeScreen({
    super.key,
    required this.userRoleMobile,
    required this.userEmail,
    required this.userName,
    required this.selectedRole,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // HomeScreen doesn't need HomeBloc - it's only for MESIN role dashboard
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (!didPop) {
            if (widget.userRoleMobile == 'CUSTOMER') {
              Navigator.of(context).pop();
            } else if (widget.selectedRole == 'PELANGGAN') {
              _navigateToRoleSelection();
            } else {
              _navigateToRoleSelection();
            }
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.backgroundWhite,
          body: SafeArea(
            child: Column(
              children: [
                AppTopBar(
                  title: _getTitleForRole(widget.userRoleMobile),
                  leading: const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/images/profile.png'),
                  ),
                ),
                Expanded(child: _buildMainContent()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToRoleSelection() {
    context.read<AppBloc>().add(const AppRoleSelected(selectedRole: ''));
  }

  String _getTitleForRole(String role) {
    if (widget.selectedRole == 'PELANGGAN') {
      return 'MerahPutih';
    }

    switch (role) {
      case 'CUSTOMER':
        return 'MerahPutih';
      case 'NON_MESIN':
        return 'Penyedia Layanan';
      case 'MESIN':
        return 'Penyedia Layanan';
      default:
        return 'MerahPutih';
    }
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Back button for role selection - show for MESIN and NON_MESIN users
          if (widget.userRoleMobile == 'NON_MESIN' ||
              widget.userRoleMobile == 'MESIN')
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _navigateToRoleSelection,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.arrow_back,
                            color: AppColors.textBlack,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.selectedRole == 'PELANGGAN'
                                ? 'Pelanggan'
                                : widget.selectedRole == 'NON_MESIN'
                                ? 'Penyedia Layanan Non Mesin'
                                : widget.selectedRole == 'MESIN'
                                ? 'Penyedia Layanan Mesin'
                                : 'Penyedia Layanan',
                            style: AppText.kaiseiRegular.copyWith(
                              color: AppColors.textBlack,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // const SizedBox(height: 16),
          // Use a separate widget that won't rebuild with carousel changes
          ServicesSection(
            userRoleMobile: widget.userRoleMobile,
            selectedRole: widget.selectedRole,
          ),
          const SizedBox(height: 20),
          // Promo Section Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Promo',
                style: AppText.kaiseiRegular.copyWith(
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
                  style: AppText.kaiseiRegular.copyWith(
                    fontSize: 14,
                    color: AppColors.primaryRed,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          RepaintBoundary(child: ImageCarouselWidget()),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// Separate widget for services that won't rebuild with carousel changes
class ServicesSection extends StatefulWidget {
  final String userRoleMobile;
  final String selectedRole;
  const ServicesSection({
    super.key,
    required this.userRoleMobile,
    required this.selectedRole,
  });

  @override
  State<ServicesSection> createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<ServicesSection>
    with AutomaticKeepAliveClientMixin {
  // Local cache for this section
  final Map<String, String> _svgCache = {};

  // Keep this widget alive even when parent rebuilds
  @override
  bool get wantKeepAlive => false;

  @override
  void initState() {
    super.initState();
    _preloadServiceIcons();
  }

  @override
  void didUpdateWidget(ServicesSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Clear cache when role changes
    if (oldWidget.userRoleMobile != widget.userRoleMobile ||
        oldWidget.selectedRole != widget.selectedRole) {
      _svgCache.clear();
      _preloadServiceIcons();
    }
  }

  void _preloadServiceIcons() {
    final serviceImages = [
      'assets/images/SetorTunai.svg',
      // 'assets/images/NonTunai.svg',
      // 'assets/images/KirimUang.svg',
      // 'assets/images/BayarTagihan.svg',
      // 'assets/images/KirimBarang.svg',
      // 'assets/images/IsiUlang.svg',
      // // 'assets/images/Pinjaman.svg',
      // 'assets/images/KirimBarang2.svg',
      // 'assets/images/Lainnya.svg',
    ];

    for (final imagePath in serviceImages) {
      _loadSvgContent(imagePath);
    }
  }

  List<Map<String, dynamic>> _getServicesForRole(
    String role,
    String selectedRole,
  ) {
    if (role == 'CUSTOMER' || selectedRole == 'PELANGGAN') {
      return [
        {
          'name': 'Setor Tunai',
          'image': 'assets/images/setor_tunai.png',
          'color': Colors.red,
        },
        {
          'name': 'Non Tunai',
          'image': 'assets/images/under_dev.png',
          'color': Colors.red,
        },
        {
          'name': 'Kirim Uang',
          'image': 'assets/images/under_dev.png',
          'color': Colors.red,
        },
        // {
        //   'name': 'Kirim Uang',
        //   'image': 'assets/images/KirimUang.svg',
        //   'color': Colors.red,
        //   'disabled': true,
        // },
        // {
        //   'name': 'Bayar Tagihan',
        //   'image': 'assets/images/BayarTagihan.svg',
        //   'color': Colors.red,
        //   'disabled': true,
        // },
        // {
        //   'name': 'Kirim Barang',
        //   'image': 'assets/images/KirimBarang.svg',
        //   'color': Colors.red,
        //   'disabled': true,
        // },
        // {
        //   'name': 'Isi ulang',
        //   'image': 'assets/images/IsiUlang.svg',
        //   'color': Colors.red,
        //   'disabled': true,
        // },
        // {
        //   'name': 'Pinjaman',
        //   'image': 'assets/images/Pinjaman.svg',
        //   'color': Colors.red,
        //   'disabled': true,
        // },
        // {
        //   'name': 'Kirim Barang',
        //   'image': 'assets/images/KirimBarang2.svg',
        //   'color': Colors.red,
        //   'disabled': true,
        // },
        // {
        //   'name': 'Lainnya',
        //   'image': 'assets/images/Lainnya.svg',
        //   'color': Colors.red,
        //   'disabled': true,
        // },
      ];
    } else if (role == 'NON_MESIN' && selectedRole != 'PELANGGAN') {
      return [
        {
          'name': 'Scan QR',
          'image': 'assets/images/scanner.svg',
          'color': Colors.red,
          'disabled': true,
        },
        {
          'name': 'Riwayat Transaksi',
          'image': 'assets/images/riwayat_transaksi.png',
          'color': Colors.red,
          'disabled': false,
        },
        {
          'name': 'FAQ',
          'image': 'assets/images/faq.png',
          'color': Colors.red,
          'disabled': false,
        },
        {
          'name': 'Bantuan',
          'image': 'assets/images/bantuan.png',
          'color': Colors.red,
          'disabled': false,
        },
      ];
    } else if (role == 'MESIN' && selectedRole != 'PELANGGAN') {
      return [
        {
          'name': 'Komisi',
          'image': 'assets/images/komisi.png',
          'color': Colors.green,
          'disabled': false,
        },
        {
          'name': 'Riwayat Transaksi',
          'image': 'assets/images/riwayat_transaksi.png',
          'color': Colors.green,
          'disabled': false,
        },
        {
          'name': 'FAQ',
          'image': 'assets/images/faq.png',
          'color': Colors.green,
          'disabled': false,
        },
        {
          'name': 'Bantuan',
          'image': 'assets/images/bantuan.png',
          'color': Colors.green,
          'disabled': false,
        },
      ];
    } else {
      return [];
    }
  }

  Future<String> _loadSvgContent(String imagePath) async {
    if (_svgCache.containsKey(imagePath)) {
      return _svgCache[imagePath]!;
    }

    try {
      // Check if the file is SVG or PNG
      if (imagePath.toLowerCase().endsWith('.svg')) {
        // Load SVG content as string
        final assetBundle = DefaultAssetBundle.of(context);
        final content = await assetBundle.loadString(imagePath);
        _svgCache[imagePath] = content;
        return content;
      } else if (imagePath.toLowerCase().endsWith('.png')) {
        // For PNG files, return a special marker to indicate it's a PNG
        // The calling code should handle PNG files differently
        _svgCache[imagePath] = 'PNG_FILE';
        return 'PNG_FILE';
      } else {
        // Try to load as SVG by default for backward compatibility
        final assetBundle = DefaultAssetBundle.of(context);
        final content = await assetBundle.loadString(imagePath);
        _svgCache[imagePath] = content;
        return content;
      }
    } catch (e) {
      print('Error loading image content: $e');
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
    final services = _getServicesForRole(
      widget.userRoleMobile,
      widget.selectedRole,
    );

    // Use 2x2 grid for MESIN and NON_MESIN roles, 3-column grid for others
    final crossAxisCount =
        ((widget.userRoleMobile == 'MESIN' ||
                widget.userRoleMobile == 'NON_MESIN') &&
            widget.selectedRole != 'PELANGGAN')
        ? 2
        : 3;
    final childAspectRatio =
        ((widget.userRoleMobile == 'MESIN' ||
                widget.userRoleMobile == 'NON_MESIN') &&
            widget.selectedRole != 'PELANGGAN')
        ? 1.0
        : 0.8;

    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: childAspectRatio,
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
      key: ValueKey('${service['name']}_${service['disabled'] ?? false}'),
      child: GestureDetector(
        onTap: (service['disabled'] ?? false)
            ? null
            : () {
                if (service['name'] == 'Lainnya') {
                } else if (service['name'] == 'Setor Tunai') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SetorTunaiScreen(),
                    ),
                  );
                } else if (service['name'] == 'Scan QR') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QRScannerScreen(),
                    ),
                  );
                } else if (service['name'] == 'KOMISI') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const KomisiScreen(),
                    ),
                  );
                } else if (service['name'] == 'Komisi') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const KomisiScreen(),
                    ),
                  );
                } else if (service['name'] == 'Riwayat Transaksi' ||
                    service['name'] == 'Riwayat Layanan') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SetorTunaiHistoryScreen(),
                    ),
                  );
                } else if (service['name'] == 'FAQ') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FAQScreen()),
                  );
                } else if (service['name'] == 'Bantuan') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SetorTunaiHelpScreen(),
                    ),
                  );
                }
              },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
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
                  child: Center(
                    child: _buildServiceIcon(
                      service['image'],
                      service['color'],
                      service['disabled'] ?? false,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                service['name'],
                style: AppText.kaiseiRegular.copyWith(
                  fontSize: 12,
                  fontWeight: (service['disabled'] ?? false)
                      ? FontWeight.w400
                      : FontWeight.w500,
                  color: (service['disabled'] ?? false)
                      ? Colors.grey[500]
                      : Colors.black,
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

  Widget _buildServiceIcon(String imagePath, Color color, bool disabled) {
    // Always rebuild to ensure disabled state is properly applied
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

        final content = snapshot.data!;

        // Handle PNG files
        if (content == 'PNG_FILE') {
          return RepaintBoundary(
            child: Stack(
              children: [
                Image.asset(
                  imagePath,
                  width: 65,
                  height: 65,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    print('Service PNG Error for $imagePath: $error');
                    return Container(
                      width: 65,
                      height: 65,
                      color: Colors.grey[200],
                      child: Icon(Icons.image, color: color, size: 20),
                    );
                  },
                ),
                if (disabled)
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Icon(Icons.block, color: Colors.white, size: 24),
                    ),
                  ),
              ],
            ),
          );
        }
        // Handle base64 PNG content
        else if (content.contains('data:image/png;base64,')) {
          return RepaintBoundary(
            child: Stack(
              children: [
                _buildBase64Image(content),
                if (disabled)
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Icon(Icons.block, color: Colors.white, size: 24),
                    ),
                  ),
              ],
            ),
          );
        }
        // Handle SVG files
        else {
          return RepaintBoundary(
            child: Stack(
              children: [
                SvgPicture.asset(
                  imagePath,
                  width: 65,
                  height: 65,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    print('Service SVG Error for $imagePath: $error');
                    return Container(
                      width: 65,
                      height: 65,
                      color: Colors.grey[200],
                      child: Icon(Icons.image, color: color, size: 20),
                    );
                  },
                ),
                if (disabled)
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Icon(Icons.block, color: Colors.white, size: 24),
                    ),
                  ),
              ],
            ),
          );
        }
      },
    );
  }
}

class ImageCarouselWidget extends StatefulWidget {
  const ImageCarouselWidget({super.key});

  @override
  State<ImageCarouselWidget> createState() => _ImageCarouselWidgetState();
}

class _ImageCarouselWidgetState extends State<ImageCarouselWidget> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;
  final Map<String, String> _svgCache = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
    _preloadCarouselImages();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _preloadCarouselImages() {
    final carouselImages = [
      'assets/images/promo1.svg',
      'assets/images/ForgotPassword.svg',
    ];

    for (final imagePath in carouselImages) {
      if (imagePath.endsWith('.svg')) {
        _loadSvgContent(imagePath);
      }
    }
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        if (_currentPage < 1) {
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
    final List<String> carouselImages = [
      'assets/images/promo1.svg',
      'assets/images/ForgotPassword.svg',
    ];

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              if (mounted) {
                setState(() {
                  _currentPage = index;
                });
              }
            },
            itemCount: carouselImages.length,
            itemBuilder: (context, index) {
              return RepaintBoundary(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
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
                    : Colors.grey.withOpacity(0.3),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildImageWidget(String imagePath) {
    // Handle PNG files directly
    if (imagePath.toLowerCase().endsWith('.png')) {
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
    // Handle SVG files
    else if (imagePath.toLowerCase().endsWith('.svg')) {
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

          final content = snapshot.data!;
          if (content == 'PNG_FILE') {
            // This shouldn't happen for SVG files, but handle it gracefully
            return RepaintBoundary(
              child: Image.asset(
                imagePath,
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
            );
          } else if (content.contains('data:image/png;base64,')) {
            return RepaintBoundary(child: _buildBase64Image(content));
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
    }
    // Handle other image types (fallback)
    else {
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
    if (_svgCache.containsKey(imagePath)) {
      return _svgCache[imagePath]!;
    }

    try {
      // Check if the file is SVG or PNG
      if (imagePath.toLowerCase().endsWith('.svg')) {
        // Load SVG content as string
        final assetBundle = DefaultAssetBundle.of(context);
        final content = await assetBundle.loadString(imagePath);
        _svgCache[imagePath] = content;
        return content;
      } else if (imagePath.toLowerCase().endsWith('.png')) {
        // For PNG files, return a special marker to indicate it's a PNG
        // The calling code should handle PNG files differently
        _svgCache[imagePath] = 'PNG_FILE';
        return 'PNG_FILE';
      } else {
        // Try to load as SVG by default for backward compatibility
        final assetBundle = DefaultAssetBundle.of(context);
        final content = await assetBundle.loadString(imagePath);
        _svgCache[imagePath] = content;
        return content;
      }
    } catch (e) {
      print('Error loading image content: $e');
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
