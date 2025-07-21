import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_text.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoginPressed = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement login logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login functionality will be implemented here'),
          backgroundColor: AppColors.primaryRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo and app name
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      Image.asset(
                        'assets/images/MP-Logo.png',
                        width: 140,
                        height: 140,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 10),
                      Image.asset(
                        'assets/images/SMARTMobsText.png',
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Login title
                Center(
                  child: Text(
                    AppText.loginTitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Phone number input
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: AppText.phoneNumberPlaceholder,
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
                      Icons.phone,
                      color: AppColors.textGray,
                      size: 20,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number or username';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Password input
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: AppText.passwordPlaceholder,
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
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.textGray,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: Text(
                      AppText.forgotPassword,
                      style: GoogleFonts.poppins(
                        color: AppColors.primaryRed,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Login button
                GestureDetector(
                  onTapDown: (_) => setState(() => _isLoginPressed = true),
                  onTapUp: (_) => setState(() => _isLoginPressed = false),
                  onTapCancel: () => setState(() => _isLoginPressed = false),
                  onTap: _handleLogin,
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
                            _isLoginPressed ? 0.1 : 0.3,
                          ),
                          blurRadius: _isLoginPressed ? 4 : 8,
                          offset: Offset(0, _isLoginPressed ? 2 : 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        AppText.loginButton,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.backgroundWhite,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
