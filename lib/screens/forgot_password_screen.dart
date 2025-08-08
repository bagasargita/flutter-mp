import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/constants/app_text.dart';
import 'package:smart_mob/screens/forgot_password_otp_screen.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isPhoneValid = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _validatePhone(String value) {
    setState(() {
      _isPhoneValid = value.length >= 10;
    });
  }

  void _sendResetCode() async {
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

      // Navigate to OTP screen
      if (navigatorContext.mounted) {
        Navigator.push(
          navigatorContext,
          MaterialPageRoute(
            builder: (context) => ForgotPasswordOTPScreen(
              phoneNumber: _phoneController.text.trim(),
            ),
          ),
        );
      }
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

                // Phone Number Field
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  onChanged: _validatePhone,
                  decoration: InputDecoration(
                    labelText: 'Type your phone number',
                    hintText: '(+42)',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (value.length < 10) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description
                Text(
                  'We texted you a code to verify your phone number',
                  style: AppText.bodySmall.copyWith(color: AppColors.textGray),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Send Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isPhoneValid ? _sendResetCode : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isPhoneValid
                          ? AppColors.primaryRed
                          : Colors.grey[300],
                      foregroundColor: _isPhoneValid
                          ? Colors.white
                          : Colors.grey[600],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Send',
                      style: AppText.buttonPrimary.copyWith(
                        color: _isPhoneValid ? Colors.white : Colors.grey[600],
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
}
