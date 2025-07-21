import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_text.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToOnboarding();
  }

  void _navigateToOnboarding() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            // Main content
            Expanded(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Image.asset(
                      'assets/images/MP-Logo.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 50),
                    Image.asset(
                      'assets/images/SMARTMobsText.png',
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 8),

                    // Tagline
                    Text(
                      AppText.appTagline,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: AppColors.textGray,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppText.poweredBy,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textLightGray,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AppText.merahPutih,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.primaryRed,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
