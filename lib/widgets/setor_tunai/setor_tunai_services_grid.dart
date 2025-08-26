import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/constants/app_text.dart';
import 'package:smart_mob/screens/setor_tunai/setor_tunai_machine_selection_screen.dart';
import 'package:smart_mob/screens/setor_tunai/setor_tunai_history_screen.dart';
import 'package:smart_mob/screens/setor_tunai/setor_tunai_location_screen.dart';
import 'package:smart_mob/screens/setor_tunai/setor_tunai_help_screen.dart';

class SetorTunaiServicesGrid extends StatefulWidget {
  final Function(Map<String, dynamic>)? onMachineSelected;

  const SetorTunaiServicesGrid({super.key, this.onMachineSelected});

  @override
  State<SetorTunaiServicesGrid> createState() => _SetorTunaiServicesGridState();
}

class _SetorTunaiServicesGridState extends State<SetorTunaiServicesGrid> {
  // Cache for SVG content to prevent reloading
  final Map<String, String> _svgCache = {};

  @override
  void initState() {
    super.initState();
    _preloadServiceIcons();
  }

  void _preloadServiceIcons() {
    final serviceImages = [
      'assets/images/Setor.svg',
      'assets/images/Riwayat.svg',
      'assets/images/Lokasi.svg',
      'assets/images/Bantuan.svg',
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
                child: const Icon(Icons.image, size: 32, color: Colors.grey),
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
      child: const Icon(Icons.image, size: 32, color: Colors.grey),
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
            width: 32,
            height: 32,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              print('Service SVG Error for $imagePath: $error');
              return Container(
                width: 32,
                height: 32,
                color: Colors.grey[200],
                child: Icon(Icons.image, color: color, size: 16),
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
            width: 32,
            height: 32,
            color: Colors.grey[200],
            child: Icon(Icons.image, color: color, size: 16),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Container(
            width: 32,
            height: 32,
            color: Colors.grey[200],
            child: Icon(Icons.image, color: color, size: 16),
          );
        }

        final svgContent = snapshot.data!;
        if (svgContent.contains('data:image/png;base64,')) {
          return RepaintBoundary(child: _buildBase64Image(svgContent));
        } else {
          return RepaintBoundary(
            child: SvgPicture.asset(
              imagePath,
              width: 32,
              height: 32,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                print('Service SVG Error for $imagePath: $error');
                return Container(
                  width: 32,
                  height: 32,
                  color: Colors.grey[200],
                  child: Icon(Icons.image, color: color, size: 16),
                );
              },
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final services = [
      {
        'name': 'Setor',
        'image': 'assets/images/Setor.svg',
        'color': Colors.red,
        'onTap': () async {
          print('Setor service tapped'); // Debug print
          // Navigate to machine selection screen
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SetorTunaiMachineSelectionScreen(),
            ),
          );

          print('Returned from machine selection: $result'); // Debug print
          // If machine was selected from machine details screen, call the callback
          if (result != null && result is Map<String, dynamic>) {
            print('Calling onMachineSelected callback'); // Debug print
            if (widget.onMachineSelected != null) {
              widget.onMachineSelected!(result);
            }
          }
        },
      },
      {
        'name': 'Riwayat',
        'image': 'assets/images/Riwayat.svg',
        'color': Colors.blue,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SetorTunaiHistoryScreen(),
          ),
        ),
      },
      {
        'name': 'Lokasi',
        'image': 'assets/images/Lokasi.svg',
        'color': Colors.green,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SetorTunaiLocationScreen(),
          ),
        ),
      },
      {
        'name': 'Bantuan',
        'image': 'assets/images/Bantuan.svg',
        'color': Colors.orange,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SetorTunaiHelpScreen()),
        ),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
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
      onTap: service['onTap'],
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(243, 239, 239, 1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
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
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: service['color'].withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: _buildServiceIcon(service['image'], service['color']),
            ),
            const SizedBox(height: 12),
            Text(
              service['name'],
              style: AppText.bodyMedium.copyWith(
                color: AppColors.textBlack,
                fontWeight: FontWeight.w600,
              ),
              textScaler: TextScaler.linear(1.0),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
