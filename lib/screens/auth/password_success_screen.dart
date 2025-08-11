import 'package:flutter/material.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/constants/app_text.dart';
import 'package:smart_mob/screens/auth/login_screen.dart';

class PasswordSuccessScreen extends StatefulWidget {
  const PasswordSuccessScreen({super.key});

  @override
  State<PasswordSuccessScreen> createState() => _PasswordSuccessScreenState();
}

class _PasswordSuccessScreenState extends State<PasswordSuccessScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _goToLogin();
      }
    });
  }

  void _goToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primaryRed, AppColors.primaryBlue],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 60,
                      color: AppColors.primaryRed,
                    ),
                  ),
                  const SizedBox(height: 32),

                  Text(
                    'Password Changed!',
                    style: AppText.heading2.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                    textScaler: TextScaler.linear(1.0),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Your password has been successfully changed. You can now log in with your new password.',
                    style: AppText.description.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                    textScaler: TextScaler.linear(1.0),
                  ),
                  const SizedBox(height: 48),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _goToLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primaryRed,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Continue to Login',
                        style: AppText.buttonPrimary.copyWith(
                          color: AppColors.primaryRed,
                        ),
                        textScaler: TextScaler.linear(1.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'You will be automatically redirected in a few seconds...',
                    style: AppText.bodySmall.copyWith(color: Colors.white70),
                    textAlign: TextAlign.center,
                    textScaler: TextScaler.linear(1.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
