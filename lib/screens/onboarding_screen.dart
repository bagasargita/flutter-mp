import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/constants/app_text.dart';
import 'package:smart_mob/screens/auth/login_screen.dart';
import 'package:smart_mob/features/onboarding/presentation/bloc/onboarding_bloc.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late OnboardingBloc _onboardingBloc;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _onboardingBloc = OnboardingBloc()..add(const OnboardingStarted());
  }

  @override
  void dispose() {
    _onboardingBloc.close();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _onboardingBloc.add(const OnboardingCompleted());
    }
  }

  void _skipOnboarding() {
    _onboardingBloc.add(const OnboardingSkipped());
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: BlocProvider.value(
        value: _onboardingBloc,
        child: BlocListener<OnboardingBloc, OnboardingState>(
          listener: (context, state) {
            if (state is OnboardingFinished) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            }
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                PageView(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  children: [
                    _buildWelcomePage(),
                    _buildSavingPage(),
                    _buildEasyFastPage(),
                    _buildFlexiblePage(),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white,
                          Color(0xFFFFF5F5),
                          Color(0xFFFFEBEB),
                        ],
                        stops: [0.0, 0.7, 1.0],
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildPaginationDots(),
                        const SizedBox(height: 30),
                        _buildActionButton(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
                if (_currentPage < 3)
                  Positioned(
                    top: 60,
                    right: 20,
                    child: TextButton(
                      onPressed: _skipOnboarding,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          fontFamily: 'Amaranth',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryRed,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        SizedBox(
          width: 160,
          height: 160,
          child: Image.asset('assets/images/MP-Logo.png', height: 160),
        ),
        const SizedBox(height: 100),
        Text(
          'Welcome to',
          style: AppText.heading1.copyWith(
            color: AppColors.textBlack,
            fontSize: 28,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'MerahPutih',
          style: AppText.kalamBold.copyWith(
            fontSize: 36,
            fontWeight: FontWeight.w900,
            color: AppColors.primaryRed,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildSavingPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 80),
        Image.asset('assets/images/Savings-Money.png', height: 280),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              Text(
                'Saving Your Money',
                style: TextStyle(
                  fontFamily: 'Amaranth',
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textBlack,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppText.bodyLarge.copyWith(
                    color: AppColors.textGray,
                    fontSize: 16,
                  ),
                  children: [
                    const TextSpan(
                      text:
                          'Track the progress of your savings and start a habit of saving with ',
                    ),
                    TextSpan(
                      text: 'MerahPutih',
                      style: TextStyle(
                        color: AppColors.primaryRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEasyFastPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 80),
        Image.asset('assets/images/Easy-Fast.png', height: 280),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              Text(
                'Easy, Fast & Trusted',
                style: TextStyle(
                  fontFamily: 'Amaranth',
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textBlack,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Money transfer and guaranteed safe transactions with others.',
                style: AppText.bodyLarge.copyWith(
                  color: AppColors.textGray,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFlexiblePage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 80),
        Image.asset('assets/images/Flexible-Transaction.png', height: 280),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              Text(
                'Flexible transactions',
                style: TextStyle(
                  fontFamily: 'Amaranth',
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textBlack,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppText.bodyLarge.copyWith(
                    color: AppColors.textGray,
                    fontSize: 16,
                  ),
                  children: [
                    const TextSpan(
                      text:
                          'Cash or non-cash deposit, transfer, pickup and delivery packages can be done anywhere in a site of ',
                    ),
                    TextSpan(
                      text: 'MerahPutih',
                      style: TextStyle(
                        color: AppColors.primaryRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaginationDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: index == _currentPage ? 22 : 10,
          height: 10,
          decoration: BoxDecoration(
            color: index == _currentPage
                ? AppColors.primaryRed
                : AppColors.textGray,
            borderRadius: BorderRadius.circular(5),
          ),
        );
      }),
    );
  }

  Widget _buildActionButton() {
    String buttonText = _currentPage == 0 ? 'Get Started' : 'Continue';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: ElevatedButton(
        onPressed: _nextPage,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            fontFamily: 'Amaranth',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
