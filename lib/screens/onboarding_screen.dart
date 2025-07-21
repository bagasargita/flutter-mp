import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_text.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();
  int currentPage = 0;
  bool _isNextPressed = false;
  bool _isDonePressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IntroductionScreen(
            key: introKey,
            pages: [
              // Page 1: Welcome
              PageViewModel(
                title: "Welcome to",
                body: AppText.appTagline,
                image: _buildWelcomeContent(),
                decoration: _getPageDecoration(),
              ),

              // Page 2: Saving Your Money
              PageViewModel(
                title: AppText.onboarding2Title,
                body: AppText.onboarding2Description,
                image: _buildSavingIllustration(),
                decoration: _getPageDecoration(),
              ),

              // Page 3: Easy, Fast & Trusted
              PageViewModel(
                title: AppText.onboarding3Title,
                body: AppText.onboarding3Description,
                image: _buildSpeedIllustration(),
                decoration: _getPageDecoration(),
              ),

              // Page 4: Flexible transactions
              PageViewModel(
                title: AppText.onboarding4Title,
                body: AppText.onboarding4Description,
                image: _buildTransactionIllustration(),
                decoration: _getPageDecoration(),
              ),
            ],

            // Skip button
            skip: Text(
              'Skip',
              style: GoogleFonts.poppins(
                color: AppColors.textGray,
                fontWeight: FontWeight.w500,
              ),
            ),

            // Remove default next and done buttons
            next: const SizedBox.shrink(),
            done: const SizedBox.shrink(),

            // Dots indicator
            dotsDecorator: DotsDecorator(
              size: const Size(8.0, 8.0),
              color: AppColors.textLightGray,
              activeSize: const Size(24.0, 8.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              activeColor: AppColors.textBlack,
              spacing: const EdgeInsets.symmetric(horizontal: 4.0),
            ),
            dotsContainerDecorator: const ShapeDecoration(
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),

            // On done callback
            onDone: () => _onDone(context),
            onSkip: () => _onDone(context),
            onChange: (page) {
              setState(() {
                currentPage = page;
              });
            },
          ),

          // Custom button positioned below dots
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: currentPage < 3
                  ? GestureDetector(
                      onTapDown: (_) => setState(() => _isNextPressed = true),
                      onTapUp: (_) => setState(() => _isNextPressed = false),
                      onTapCancel: () => setState(() => _isNextPressed = false),
                      onTap: () {
                        introKey.currentState?.next();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 150,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.buttonRed,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.buttonRed.withValues(
                                alpha: _isNextPressed ? 0.1 : 0.3,
                              ),
                              blurRadius: _isNextPressed ? 4 : 8,
                              offset: Offset(0, _isNextPressed ? 2 : 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            AppText.continueText,
                            style: GoogleFonts.poppins(
                              color: AppColors.backgroundWhite,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTapDown: (_) => setState(() => _isDonePressed = true),
                      onTapUp: (_) => setState(() => _isDonePressed = false),
                      onTapCancel: () => setState(() => _isDonePressed = false),
                      onTap: () => _onDone(context),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 150,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.buttonRed,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.buttonRed.withValues(
                                alpha: _isDonePressed ? 0.1 : 0.3,
                              ),
                              blurRadius: _isDonePressed ? 4 : 8,
                              offset: Offset(0, _isDonePressed ? 2 : 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            AppText.getStarted,
                            style: GoogleFonts.poppins(
                              color: AppColors.backgroundWhite,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  PageDecoration _getPageDecoration() {
    return PageDecoration(
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: AppColors.textBlack,
        height: 1.2,
      ),
      bodyTextStyle: GoogleFonts.poppins(
        fontSize: 14.0,
        color: AppColors.textGray,
        height: 1.4,
      ),
      pageColor: AppColors.backgroundWhite,
      imagePadding: const EdgeInsets.only(top: 40, bottom: 24),
      bodyPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      titlePadding: const EdgeInsets.only(
        top: 16,
        left: 24,
        right: 24,
        bottom: 8,
      ),
      footerPadding: const EdgeInsets.only(bottom: 32),
    );
  }

  Widget _buildWelcomeContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/MP-Logo.png',
          width: 100,
          height: 100,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 24),
        Image.asset(
          'assets/images/SMARTMobsText.png',
          width: 120,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 16),
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
    );
  }

  Widget _buildSavingIllustration() {
    return Image.asset(
      'assets/images/Savings-Money.png',
      width: 200,
      height: 200,
      fit: BoxFit.contain,
    );
  }

  Widget _buildSpeedIllustration() {
    return Image.asset(
      'assets/images/Easy-Fast.png',
      width: 200,
      height: 200,
      fit: BoxFit.contain,
    );
  }

  Widget _buildTransactionIllustration() {
    return Image.asset(
      'assets/images/Flexible-Transaction.png',
      width: 200,
      height: 200,
      fit: BoxFit.contain,
    );
  }

  void _onDone(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}
