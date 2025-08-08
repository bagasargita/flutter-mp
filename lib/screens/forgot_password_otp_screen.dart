import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/constants/app_text.dart';
import 'package:smart_mob/screens/change_password_screen.dart';
import 'dart:async';

class ForgotPasswordOTPScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const ForgotPasswordOTPScreen({super.key, required this.phoneNumber});

  @override
  ConsumerState<ForgotPasswordOTPScreen> createState() =>
      _ForgotPasswordOTPScreenState();
}

class _ForgotPasswordOTPScreenState
    extends ConsumerState<ForgotPasswordOTPScreen> {
  final _formKey = GlobalKey<FormState>();
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
      _isOtpValid = value.length == 4;
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
    if (_formKey.currentState!.validate()) {
      // Store context before async operation
      final navigatorContext = context;

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Close loading dialog
      if (navigatorContext.mounted) {
        Navigator.pop(navigatorContext);
      }

      // Navigate to change password screen
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
      // Store context before async operation
      final scaffoldContext = context;

      // Show loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Resending OTP...'),
          backgroundColor: AppColors.primaryBlue,
        ),
      );

      // Simulate API call
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
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),

                // OTP Field with Resend Button
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        onChanged: _validateOtp,
                        decoration: const InputDecoration(
                          labelText: 'Type a code',
                          hintText: 'Code',
                          border: OutlineInputBorder(),
                          counterText: '',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the OTP code';
                          }
                          if (value.length != 4) {
                            return 'Please enter a 4-digit code';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: _isResendEnabled ? _resendOtp : null,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primaryRed,
                      ),
                      child: Text(
                        'Resend',
                        style: AppText.bodyMedium.copyWith(
                          color: _isResendEnabled
                              ? AppColors.primaryRed
                              : AppColors.textGray,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Description
                Text(
                  'We texted you a code to verify your phone number ${widget.phoneNumber}',
                  style: AppText.bodySmall.copyWith(color: AppColors.textGray),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Expiry message
                Text(
                  'This code will expired 10 minutes after this message. If you don\'t get a message.',
                  style: AppText.bodySmall.copyWith(color: AppColors.textGray),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Change Password Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isOtpValid ? _verifyOtp : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isOtpValid
                          ? AppColors.primaryRed
                          : Colors.grey[300],
                      foregroundColor: _isOtpValid
                          ? Colors.white
                          : Colors.grey[600],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Change password',
                      style: AppText.buttonPrimary.copyWith(
                        color: _isOtpValid ? Colors.white : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Change Phone Number Link
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Change your phone number',
                    style: AppText.bodyMedium.copyWith(
                      color: AppColors.primaryBlue,
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
}
