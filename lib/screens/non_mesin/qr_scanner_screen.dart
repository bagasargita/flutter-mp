import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:merah_putih/constants/app_colors.dart';
import 'package:merah_putih/constants/app_text.dart';
import 'package:merah_putih/widgets/common/app_top_bar.dart';
import 'package:merah_putih/core/di/service_locator.dart';
import 'package:merah_putih/screens/non_mesin/setor_tunai_confirmation_screen.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen>
    with TickerProviderStateMixin {
  MobileScannerController controller = MobileScannerController();
  bool _isFlashOn = false;
  bool _isScanning = true;
  late AnimationController _scanningAnimationController;
  late Animation<double> _scanningAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _scanningAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scanningAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scanningAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _scanningAnimationController.repeat();
  }

  @override
  void dispose() {
    _scanningAnimationController.dispose();
    controller.dispose();
    super.dispose();
  }

  Future<bool> _checkCameraPermission() async {
    final permissionService = ServiceLocator().permissionService;
    if (!permissionService.cameraPermissionGranted) {
      final granted = await permissionService.requestCameraPermission();
      if (!granted) {
        permissionService.showPermissionDialog(context, 'Kamera');
      }
      return granted;
    }
    return true;
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isScanning && capture.barcodes.isNotEmpty) {
      final barcode = capture.barcodes.first;
      if (barcode.rawValue != null) {
        setState(() {
          _isScanning = false;
        });
        _scanningAnimationController.stop();
        _handleScannedCode(barcode.rawValue!);
      }
    }
  }

  void _handleScannedCode(String code) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: AppColors.primaryRed,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                // Title
                Text(
                  'QR Code Berhasil Dipindai',
                  style: AppText.kaiseiRegular.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Data yang dipindai:',
                  style: AppText.kaiseiRegular.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 12),
                // QR Code content
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!, width: 1),
                  ),
                  child: SelectableText(
                    code,
                    style: AppText.kaiseiRegular.copyWith(
                      fontSize: 12,
                      fontFamily: 'monospace',
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            _isScanning = true;
                          });
                          _scanningAnimationController.repeat();
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.primaryRed),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Scan Lagi',
                          style: TextStyle(
                            color: AppColors.primaryRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _processQRCode(code);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 2,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              'Proses',
                              style: AppText.kaiseiRegular.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _processQRCode(String code) {
    // Navigate to confirmation screen with scanned QR code
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SetorTunaiConfirmationScreen(
          qrCode: code,
          transactionData: {
            'transactionId': 'XXXXXXXX',
            'company': 'PT ABC',
            'agent': 'Toko Mitra 10',
            'description': 'Lorem Ipsum Dulur Sit',
            'total': 'Rp. 5.000.000,-',
          },
        ),
      ),
    );
  }

  void _toggleFlash() {
    controller.toggleTorch();
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
  }

  void _resumeScanning() {
    setState(() {
      _isScanning = true;
    });
    controller.start();
    _scanningAnimationController.repeat();
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
    bool isPrimary = false,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(25),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isPrimary
                  ? AppColors.primaryRed
                  : isActive
                  ? AppColors.primaryRed.withOpacity(0.2)
                  : Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: isPrimary
                    ? AppColors.primaryRed
                    : isActive
                    ? AppColors.primaryRed
                    : Colors.white.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: isPrimary || isActive
                  ? [
                      BoxShadow(
                        color: AppColors.primaryRed.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedScale(
                  scale: isActive ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    icon,
                    color: isPrimary || isActive
                        ? Colors.white
                        : Colors.white70,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: AppText.kaiseiRegular.copyWith(
                    color: isPrimary || isActive
                        ? Colors.white
                        : Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionDeniedView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryRed.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.camera_alt_outlined,
              size: 60,
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'Akses Kamera Diperlukan',
            style: AppText.kaiseiRegular.copyWith(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Untuk memindai QR Code, aplikasi memerlukan akses kamera. Silakan berikan izin untuk melanjutkan.',
              style: AppText.kaiseiRegular.copyWith(
                color: Colors.white70,
                fontSize: 14,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () async {
              final granted = await _checkCameraPermission();
              if (granted) {
                setState(() {}); // Refresh the UI
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.camera_alt, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Berikan Izin Kamera',
                  style: AppText.kaiseiRegular.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              AppTopBar(title: 'Scan QR Code', showBack: true),
              Expanded(
                child:
                    !ServiceLocator().permissionService.cameraPermissionGranted
                    ? _buildPermissionDeniedView()
                    : Stack(
                        children: [
                          MobileScanner(
                            controller: controller,
                            onDetect: _onDetect,
                          ),
                          // Custom overlay for scanning area
                          Positioned.fill(
                            child: AnimatedBuilder(
                              animation: _scanningAnimation,
                              builder: (context, child) {
                                return CustomPaint(
                                  painter: QRScannerOverlayPainter(
                                    borderColor: AppColors.primaryRed,
                                    cutOutSize: 250,
                                    scanningProgress: _scanningAnimation.value,
                                  ),
                                );
                              },
                            ),
                          ),
                          // Top instruction text
                          Positioned(
                            top: 20,
                            left: 20,
                            right: 20,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: AppColors.primaryRed.withOpacity(0.3),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryRed.withOpacity(
                                      0.1,
                                    ),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryRed.withOpacity(
                                        0.2,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.qr_code_scanner,
                                      color: AppColors.primaryRed,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Arahkan kamera ke QR Code',
                                    style: AppText.kaiseiRegular.copyWith(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Bottom controls
                          Positioned(
                            bottom: 30,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                children: [
                                  // Scanning indicator
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryRed.withOpacity(
                                        0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: AppColors.primaryRed.withOpacity(
                                          0.3,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryRed,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.primaryRed
                                                    .withOpacity(0.5),
                                                blurRadius: 4,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Sedang memindai...',
                                          style: AppText.kaiseiRegular.copyWith(
                                            color: AppColors.primaryRed,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  // Control buttons
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // Flash toggle button
                                      _buildControlButton(
                                        icon: _isFlashOn
                                            ? Icons.flash_on
                                            : Icons.flash_off,
                                        label: _isFlashOn
                                            ? 'Flash On'
                                            : 'Flash Off',
                                        onTap: _toggleFlash,
                                        isActive: _isFlashOn,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
}

enum CutOutCorner { topLeft, topRight, bottomLeft, bottomRight }

class QRScannerOverlayPainter extends CustomPainter {
  final Color borderColor;
  final double cutOutSize;
  final double scanningProgress;

  QRScannerOverlayPainter({
    required this.borderColor,
    required this.cutOutSize,
    required this.scanningProgress,
  });

  void _drawRoundedCorner(
    Canvas canvas,
    Offset cornerPosition,
    double cornerLength,
    double cornerWidth,
    double cornerRadius,
    Color borderColor,
    LinearGradient gradient,
    CutOutCorner cornerType,
  ) {
    final gradientPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(
          cornerPosition.dx - cornerLength,
          cornerPosition.dy - cornerLength,
          cornerLength * 2,
          cornerLength * 2,
        ),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = cornerWidth
      ..strokeCap = StrokeCap.round;

    Path cornerPath = Path();

    switch (cornerType) {
      case CutOutCorner.topLeft:
        cornerPath.moveTo(cornerPosition.dx, cornerPosition.dy + cornerLength);
        cornerPath.lineTo(cornerPosition.dx, cornerPosition.dy + cornerRadius);
        cornerPath.quadraticBezierTo(
          cornerPosition.dx,
          cornerPosition.dy,
          cornerPosition.dx + cornerRadius,
          cornerPosition.dy,
        );
        cornerPath.lineTo(cornerPosition.dx + cornerLength, cornerPosition.dy);
        break;
      case CutOutCorner.topRight:
        cornerPath.moveTo(cornerPosition.dx - cornerLength, cornerPosition.dy);
        cornerPath.lineTo(cornerPosition.dx - cornerRadius, cornerPosition.dy);
        cornerPath.quadraticBezierTo(
          cornerPosition.dx,
          cornerPosition.dy,
          cornerPosition.dx,
          cornerPosition.dy + cornerRadius,
        );
        cornerPath.lineTo(cornerPosition.dx, cornerPosition.dy + cornerLength);
        break;
      case CutOutCorner.bottomLeft:
        cornerPath.moveTo(cornerPosition.dx, cornerPosition.dy - cornerLength);
        cornerPath.lineTo(cornerPosition.dx, cornerPosition.dy - cornerRadius);
        cornerPath.quadraticBezierTo(
          cornerPosition.dx,
          cornerPosition.dy,
          cornerPosition.dx + cornerRadius,
          cornerPosition.dy,
        );
        cornerPath.lineTo(cornerPosition.dx + cornerLength, cornerPosition.dy);
        break;
      case CutOutCorner.bottomRight:
        cornerPath.moveTo(cornerPosition.dx - cornerLength, cornerPosition.dy);
        cornerPath.lineTo(cornerPosition.dx - cornerRadius, cornerPosition.dy);
        cornerPath.quadraticBezierTo(
          cornerPosition.dx,
          cornerPosition.dy,
          cornerPosition.dx,
          cornerPosition.dy - cornerRadius,
        );
        cornerPath.lineTo(cornerPosition.dx, cornerPosition.dy - cornerLength);
        break;
    }

    // Draw the corner with gradient
    canvas.drawPath(cornerPath, gradientPaint);

    // Add inner glow effect
    final glowPaint = Paint()
      ..color = borderColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = cornerWidth * 0.5
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(cornerPath, glowPaint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    // Calculate the cut-out rectangle
    final cutOutRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: cutOutSize,
      height: cutOutSize,
    );

    // Create path for the entire screen
    final screenPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Create path for the cut-out area
    final cutOutPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(cutOutRect, const Radius.circular(16)),
      );

    // Create the overlay by subtracting the cut-out from the screen
    final overlayPath = Path.combine(
      PathOperation.difference,
      screenPath,
      cutOutPath,
    );

    // Draw the overlay
    canvas.drawPath(overlayPath, paint);

    // Draw the main border around the cut-out
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRRect(
      RRect.fromRectAndRadius(cutOutRect, const Radius.circular(16)),
      borderPaint,
    );

    // Draw corner indicators with proper rounded design
    final cornerLength = 45.0;
    final cornerWidth = 4.0;
    final cornerRadius = 12.0;

    // Create animated gradient paint for corners
    final animationOffset = (scanningProgress * 2.0) % 1.0;
    final cornerGradient = LinearGradient(
      colors: [
        borderColor.withOpacity(0.3 + animationOffset * 0.7),
        borderColor.withOpacity(0.8 + animationOffset * 0.2),
        borderColor.withOpacity(0.4 + animationOffset * 0.6),
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    // Top-left corner
    _drawRoundedCorner(
      canvas,
      Offset(cutOutRect.left, cutOutRect.top),
      cornerLength,
      cornerWidth,
      cornerRadius,
      borderColor,
      cornerGradient,
      CutOutCorner.topLeft,
    );

    // Top-right corner
    _drawRoundedCorner(
      canvas,
      Offset(cutOutRect.right, cutOutRect.top),
      cornerLength,
      cornerWidth,
      cornerRadius,
      borderColor,
      cornerGradient,
      CutOutCorner.topRight,
    );

    // Bottom-left corner
    _drawRoundedCorner(
      canvas,
      Offset(cutOutRect.left, cutOutRect.bottom),
      cornerLength,
      cornerWidth,
      cornerRadius,
      borderColor,
      cornerGradient,
      CutOutCorner.bottomLeft,
    );

    // Bottom-right corner
    _drawRoundedCorner(
      canvas,
      Offset(cutOutRect.right, cutOutRect.bottom),
      cornerLength,
      cornerWidth,
      cornerRadius,
      borderColor,
      cornerGradient,
      CutOutCorner.bottomRight,
    );

    // Add animated scanning line effect with enhanced design
    final scanningLineRect = Rect.fromLTRB(
      cutOutRect.left + 15,
      cutOutRect.top + 15,
      cutOutRect.right - 15,
      cutOutRect.bottom - 15,
    );

    // Calculate animated scanning line position
    final lineY =
        scanningLineRect.top + (scanningLineRect.height * scanningProgress);

    // Create gradient effect for scanning line
    final gradientShader = LinearGradient(
      colors: [
        borderColor.withOpacity(0.0),
        borderColor.withOpacity(0.3),
        borderColor.withOpacity(0.9),
        borderColor.withOpacity(0.3),
        borderColor.withOpacity(0.0),
      ],
      stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
    ).createShader(scanningLineRect);

    // Draw main scanning line with gradient
    final gradientPaint = Paint()
      ..shader = gradientShader
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(scanningLineRect.left, lineY),
      Offset(scanningLineRect.right, lineY),
      gradientPaint,
    );

    // Add inner glow effect
    final glowPaint = Paint()
      ..color = borderColor.withOpacity(0.6)
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(scanningLineRect.left, lineY),
      Offset(scanningLineRect.right, lineY),
      glowPaint,
    );

    // Add scanning line dots for better visual effect
    final dotCount = 8;
    final dotSpacing = scanningLineRect.width / (dotCount - 1);

    for (int i = 0; i < dotCount; i++) {
      final dotX = scanningLineRect.left + (i * dotSpacing);
      final dotOpacity = (1.0 - (i / (dotCount - 1))).clamp(0.0, 1.0);

      final dotPaint = Paint()
        ..color = borderColor.withOpacity(dotOpacity * 0.8)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(dotX, lineY), 2.0, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant QRScannerOverlayPainter oldDelegate) {
    return oldDelegate.scanningProgress != scanningProgress ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.cutOutSize != cutOutSize;
  }
}
