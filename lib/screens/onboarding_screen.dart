import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/constants/app_text.dart';
import 'package:smart_mob/screens/login_screen.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  Widget _buildCustomTitle(
    String firstPart,
    String middlePart,
    String secondPart,
    TextStyle? style1,
    TextStyle? style2,
    TextStyle? style3,
  ) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(text: firstPart, style: style1),
          TextSpan(text: middlePart, style: style2),
          TextSpan(text: secondPart, style: style3),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "",
          body: "Your Best Cash Partner for all your financial needs",
          image: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              Image.asset('assets/images/MP-Logo.png', height: 160),
              const SizedBox(height: 40),
              _buildCustomTitle(
                "Welcome to",
                "\n",
                "SMARTMobs",
                AppText.heading1.copyWith(color: AppColors.textBlack),
                AppText.description.copyWith(color: AppColors.textLightGray),
                AppText.kalamBold.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryRed,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          decoration: PageDecoration(
            titleTextStyle: AppText.heading1,
            bodyTextStyle: AppText.description,
            pageColor: Colors.white,
            imageAlignment: Alignment.center,
            imagePadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 30,
            ),
            imageFlex: 2,
            bodyAlignment: Alignment.center,
            bodyPadding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 20,
            ),
          ),
        ),
        PageViewModel(
          title: "Saving Your Money",
          body:
              "Track the progress of your savings and start a habit of saving with SMARTMobs",
          image: Image.asset('assets/images/Savings-Money.png', height: 300),
          decoration: PageDecoration(
            titleTextStyle: TextStyle(
              fontFamily: 'Amaranth',
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: AppColors.textBlack,
            ),
            bodyTextStyle: AppText.description.copyWith(
              color: AppColors.textGray,
            ),
            pageColor: Colors.white,
            imagePadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 40,
            ),
            bodyAlignment: Alignment.center,
            bodyPadding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 20,
            ),
          ),
        ),
        PageViewModel(
          title: "Easy, Fast & Trusted",
          body: "Money transfer and guaranteed safe transactions with others",
          image: Image.asset('assets/images/Easy-Fast.png', height: 300),
          decoration: PageDecoration(
            titleTextStyle: TextStyle(
              fontFamily: 'Amaranth',
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: AppColors.textBlack,
            ),
            bodyTextStyle: AppText.description.copyWith(
              color: AppColors.textGray,
            ),
            pageColor: Colors.white,
            imagePadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 40,
            ),
            bodyAlignment: Alignment.center,
            bodyPadding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 20,
            ),
          ),
        ),
        PageViewModel(
          title: "Flexible Transactions",
          body:
              "Cash or non-cash deposit, transfer, pickup and delivery packages  can be done anywhere in a site of SMARTMobs.",
          image: Center(
            child: Image.asset(
              'assets/images/Flexible-Transaction.png',
              height: 300,
            ),
          ),
          decoration: PageDecoration(
            titleTextStyle: TextStyle(
              fontFamily: 'Amaranth',
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: AppColors.textBlack,
            ),
            bodyTextStyle: AppText.description.copyWith(
              color: AppColors.textGray,
            ),
            pageColor: Colors.white,
            imagePadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 40,
            ),
            bodyAlignment: Alignment.center,
            bodyPadding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 20,
            ),
          ),
        ),
      ],
      onDone: () {
        _completeOnboarding();
      },
      onSkip: () {
        _completeOnboarding();
      },
      showSkipButton: true,
      skip: Text(
        "Skip",
        style: TextStyle(
          fontFamily: 'Amaranth',
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryRed,
        ),
      ),
      next: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primaryRed,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
      ),
      done: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.primaryRed,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          "Continue",
          style: AppText.buttonPrimary,
          textAlign: TextAlign.center,
        ),
      ),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: AppColors.textGray,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
        activeColor: AppColors.primaryRed,
      ),
    );
  }

  void _completeOnboarding() async {
    // Save onboarding completion status
    // await ref.read(onboardingProvider.notifier).completeOnboarding();

    // Navigate to login screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}
