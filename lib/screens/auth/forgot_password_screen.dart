import 'package:flutter/material.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/constants/app_text.dart';
import 'package:smart_mob/screens/auth/forgot_password_otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
      _isPhoneValid =
          value.length >= 10 &&
          (value.startsWith('+62') || value.startsWith('08'));
    });
  }

  void _sendResetCode() async {
    if (_formKey.currentState!.validate()) {
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
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
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
            textScaler: TextScaler.linear(1.0),
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

                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    onChanged: _validatePhone,
                    decoration: InputDecoration(
                      labelText: 'Type your phone number',
                      hintText: '(+62)',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: _isPhoneValid ? _sendResetCode : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Send Reset Code',
                      style: AppText.buttonPrimary.copyWith(
                        color: Colors.white,
                      ),
                      textScaler: TextScaler.linear(1.0),
                    ),
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
