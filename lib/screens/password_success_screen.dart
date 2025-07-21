import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import 'login_screen.dart';

class PasswordSuccessScreen extends StatefulWidget {
  const PasswordSuccessScreen({super.key});

  @override
  State<PasswordSuccessScreen> createState() => _PasswordSuccessScreenState();
}

class _PasswordSuccessScreenState extends State<PasswordSuccessScreen> {
  bool _isOkPressed = false;

  void _handleOk() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => LoginScreen(onLoginSuccess: () {}),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(
          'Change password',
          style: GoogleFonts.poppins(
            color: AppColors.textBlack,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Spacer(),

              // Success illustration
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Smartphone with checkmark
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: AppColors.backgroundWhite,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Person with shield
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.security,
                          color: AppColors.primaryRed,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.vpn_key,
                          color: AppColors.warningYellow,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.lock_open,
                          color: AppColors.warningYellow,
                          size: 24,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Success title
              Text(
                'Change password successfully!',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Success message
              Text(
                'You have successfully change password. Please use the new password when sign in.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textGray,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Ok button
              GestureDetector(
                onTapDown: (_) => setState(() => _isOkPressed = true),
                onTapUp: (_) => setState(() => _isOkPressed = false),
                onTapCancel: () => setState(() => _isOkPressed = false),
                onTap: _handleOk,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.buttonRed,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.buttonRed.withOpacity(
                          _isOkPressed ? 0.1 : 0.3,
                        ),
                        blurRadius: _isOkPressed ? 4 : 8,
                        offset: Offset(0, _isOkPressed ? 2 : 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Ok',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.backgroundWhite,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
