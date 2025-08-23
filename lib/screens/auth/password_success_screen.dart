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
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryBlue, width: 2),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/ForgotPassword.png',
                          height: 280,
                          fit: BoxFit.contain,
                        ),

                        const SizedBox(height: 32),

                        Text(
                          'Change password successfully!',
                          style: AppText.heading2.copyWith(
                            color: AppColors.primaryRed,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          textScaler: TextScaler.linear(1.0),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          'You have successfully change password. Please use the new password when Sign in.',
                          style: AppText.bodyMedium.copyWith(
                            color: AppColors.textBlack,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                          textScaler: TextScaler.linear(1.0),
                        ),

                        const SizedBox(height: 48),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _goToLogin,
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
                              'Ok',
                              style: AppText.buttonPrimary.copyWith(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                              textScaler: TextScaler.linear(1.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey[300],
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
