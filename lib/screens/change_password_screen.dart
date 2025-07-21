import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import 'password_success_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isChangePasswordPressed = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleChangePassword() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const PasswordSuccessScreen()),
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // New password input
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: !_isNewPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Type your new password',
                    labelStyle: GoogleFonts.poppins(
                      color: AppColors.textGray,
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
                      Icons.lock,
                      color: AppColors.textGray,
                      size: 20,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isNewPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.textGray,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _isNewPasswordVisible = !_isNewPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your new password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Confirm password input
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Confirm password',
                    labelStyle: GoogleFonts.poppins(
                      color: AppColors.textGray,
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
                      Icons.lock,
                      color: AppColors.textGray,
                      size: 20,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.textGray,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
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
                      color: AppColors.buttonRed,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.buttonRed.withOpacity(
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
      ),
    );
  }
}
