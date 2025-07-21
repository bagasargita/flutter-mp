import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import 'change_password_screen.dart';

class ForgotPasswordOTPScreen extends StatefulWidget {
  final String phoneNumber;

  const ForgotPasswordOTPScreen({super.key, required this.phoneNumber});

  @override
  State<ForgotPasswordOTPScreen> createState() =>
      _ForgotPasswordOTPScreenState();
}

class _ForgotPasswordOTPScreenState extends State<ForgotPasswordOTPScreen> {
  final _otpController = TextEditingController();
  bool _isChangePasswordPressed = false;
  bool _isOtpValid = false;

  @override
  void initState() {
    super.initState();
    _otpController.addListener(_validateOtp);
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _validateOtp() {
    setState(() {
      _isOtpValid = _otpController.text.length == 4;
    });
  }

  void _handleResend() {
    // TODO: Implement resend OTP logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP resent successfully'),
        backgroundColor: AppColors.successGreen,
      ),
    );
  }

  void _handleChangePassword() {
    if (_isOtpValid) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
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

              // OTP input row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      decoration: InputDecoration(
                        labelText: 'Type a code',
                        labelStyle: GoogleFonts.poppins(
                          color: AppColors.textGray,
                          fontSize: 14,
                        ),
                        hintText: 'Code',
                        hintStyle: GoogleFonts.poppins(
                          color: AppColors.textLightGray,
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: AppColors.textLightGray,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: AppColors.textLightGray,
                          ),
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
                        counterText: '',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: _handleResend,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Resend',
                        style: GoogleFonts.poppins(
                          color: AppColors.backgroundWhite,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Info text
              RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    color: AppColors.textGray,
                    fontSize: 12,
                  ),
                  children: [
                    const TextSpan(
                      text: 'We texted you a code to verify your phone number ',
                    ),
                    TextSpan(
                      text: '(+62) ${widget.phoneNumber}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const TextSpan(
                      text:
                          '. This code will expired 10 minutes after this message. If you don\'t get a message, ',
                    ),
                    TextSpan(
                      text: 'change your phone number',
                      style: TextStyle(
                        color: AppColors.primaryRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Change password button
              GestureDetector(
                onTapDown: (_) =>
                    setState(() => _isChangePasswordPressed = true),
                onTapUp: (_) =>
                    setState(() => _isChangePasswordPressed = false),
                onTapCancel: () =>
                    setState(() => _isChangePasswordPressed = false),
                onTap: _handleChangePassword,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _isOtpValid
                        ? AppColors.buttonRed
                        : AppColors.textLightGray,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color:
                            (_isOtpValid
                                    ? AppColors.buttonRed
                                    : AppColors.textLightGray)
                                .withOpacity(
                                  _isChangePasswordPressed ? 0.1 : 0.3,
                                ),
                        blurRadius: _isChangePasswordPressed ? 4 : 8,
                        offset: Offset(0, _isChangePasswordPressed ? 2 : 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Change password',
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
