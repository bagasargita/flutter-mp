import 'package:flutter/material.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/constants/app_text.dart';
import 'package:smart_mob/screens/auth/change_password_screen.dart';
import 'dart:async';

class ForgotPasswordOTPScreen extends StatefulWidget {
  final String phoneNumber;

  const ForgotPasswordOTPScreen({super.key, required this.phoneNumber});

  @override
  State<ForgotPasswordOTPScreen> createState() =>
      _ForgotPasswordOTPScreenState();
}

class _ForgotPasswordOTPScreenState extends State<ForgotPasswordOTPScreen> {
  final _otpController = TextEditingController();
  bool _isResendEnabled = true;
  bool _isOtpValid = false;
  int _resendCountdown = 60;

  @override
  void initState() {
    super.initState();
    _startResendCountdown();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _validateOtp(String value) {
    setState(() {
      _isOtpValid = value.length >= 6;
    });
  }

  void _startResendCountdown() {
    setState(() {
      _isResendEnabled = false;
      _resendCountdown = 60;
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _resendCountdown--;
        });

        if (_resendCountdown <= 0) {
          setState(() {
            _isResendEnabled = true;
          });
          timer.cancel();
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _verifyOtp() async {
    if (_otpController.text.length >= 6) {
      final navigatorContext = context;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await Future.delayed(const Duration(seconds: 2));

      if (navigatorContext.mounted) {
        Navigator.pop(navigatorContext);
      }

      if (navigatorContext.mounted) {
        Navigator.push(
          navigatorContext,
          MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
        );
      }
    }
  }

  void _resendOtp() {
    if (_isResendEnabled) {
      final scaffoldContext = context;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Resending OTP...'),
          backgroundColor: AppColors.primaryBlue,
        ),
      );

      Future.delayed(const Duration(seconds: 1), () {
        if (scaffoldContext.mounted) {
          ScaffoldMessenger.of(scaffoldContext).showSnackBar(
            const SnackBar(
              content: Text('OTP sent successfully'),
              backgroundColor: AppColors.successGreen,
            ),
          );
        }
        _startResendCountdown();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textBlack),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Forgot password',
            style: AppText.heading3.copyWith(color: AppColors.textBlack),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Type a code',
                                  style: AppText.bodyMedium.copyWith(
                                    color: AppColors.textBlack,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _otpController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 6,
                                  onChanged: _validateOtp,
                                  decoration: const InputDecoration(
                                    hintText: 'Code',
                                    counterText: '',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            height: 48,
                            child: TextButton(
                              onPressed: _isResendEnabled ? _resendOtp : null,
                              style: TextButton.styleFrom(
                                backgroundColor: AppColors.primaryRed,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                _isResendEnabled
                                    ? 'Resend'
                                    : '$_resendCountdown s',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      Text(
                        'We texted you a code to verify your phone number ${widget.phoneNumber}',
                        style: AppText.bodyMedium.copyWith(
                          color: AppColors.textGray,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        'This code will expired 10 minutes after this message. If you don\'t get a message.',
                        style: AppText.bodyMedium.copyWith(
                          color: AppColors.textGray,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isOtpValid ? _verifyOtp : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isOtpValid
                                ? AppColors.primaryRed
                                : const Color(0xFFE0E0E0),
                            foregroundColor: _isOtpValid
                                ? Colors.white
                                : const Color(0xFF9E9E9E),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Change password',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: _isOtpValid
                                  ? Colors.white
                                  : const Color(0xFF9E9E9E),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Change your phone number',
                    style: AppText.bodyMedium.copyWith(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
