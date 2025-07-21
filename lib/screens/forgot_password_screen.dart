import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import 'forgot_password_otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _phoneController = TextEditingController();
  bool _isSendPressed = false;
  bool _isPhoneValid = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validatePhone);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _validatePhone() {
    setState(() {
      _isPhoneValid = _phoneController.text.length >= 10;
    });
  }

  void _handleSend() {
    if (_isPhoneValid) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              ForgotPasswordOTPScreen(phoneNumber: _phoneController.text),
        ),
      );
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Forgot password',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Phone number input
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Type your phone number',
                  labelStyle: GoogleFonts.poppins(
                    color: AppColors.textGray,
                    fontSize: 14,
                  ),
                  hintText: '(+62)',
                  hintStyle: GoogleFonts.poppins(
                    color: AppColors.textLightGray,
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.textLightGray),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.textLightGray),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppColors.primaryRed,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  prefixIcon: const Icon(
                    Icons.phone,
                    color: AppColors.textGray,
                    size: 20,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Info text
              Text(
                'We texted you a code to verify your phone number',
                style: GoogleFonts.poppins(
                  color: AppColors.textGray,
                  fontSize: 12,
                ),
              ),

              const Spacer(),

              // Send button
              GestureDetector(
                onTapDown: (_) => setState(() => _isSendPressed = true),
                onTapUp: (_) => setState(() => _isSendPressed = false),
                onTapCancel: () => setState(() => _isSendPressed = false),
                onTap: _handleSend,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _isPhoneValid
                        ? AppColors.buttonRed
                        : AppColors.textLightGray,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color:
                            (_isPhoneValid
                                    ? AppColors.buttonRed
                                    : AppColors.textLightGray)
                                .withOpacity(_isSendPressed ? 0.1 : 0.3),
                        blurRadius: _isSendPressed ? 4 : 8,
                        offset: Offset(0, _isSendPressed ? 2 : 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Send',
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
