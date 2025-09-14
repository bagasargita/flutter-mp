import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/app/presentation/bloc/app_bloc.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  final void Function(
    String userRoleMobile,
    String userEmail,
    String userName,
    String selectedRole,
  )?
  onLoginSuccess;

  const LoginScreen({super.key, this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // Always clear all states before login attempt
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        print('LoginScreen: Clearing all states before login');
        await _clearAllStates(context);
      }
    });
  }

  Future<void> _clearAllStates(BuildContext context) async {
    try {
      // Clear AppBloc state
      context.read<AppBloc>().add(const AppLogoutRequested());

      // Clear AuthBloc state
      context.read<AuthBloc>().add(const AuthLogoutRequested());

      // Wait for state clearing to complete
      await Future.delayed(const Duration(milliseconds: 300));

      print('LoginScreen: All states cleared successfully');
    } catch (e) {
      print('LoginScreen: Error clearing states: $e');
    }
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Determine the appropriate selectedRole based on user role
            String selectedRole = '';
            if (state.user.roleMobile == 'CUSTOMER') {
              selectedRole = 'CUSTOMER'; // CUSTOMER goes directly to home
            } else if (state.user.roleMobile == 'NON_MESIN' ||
                state.user.roleMobile == 'MESIN') {
              selectedRole = ''; // Empty for role selection
            }

            // Trigger the login success callback with proper data
            if (widget.onLoginSuccess != null) {
              print(
                'Login success callback - Role: ${state.user.roleMobile}, SelectedRole: $selectedRole',
              );
              // Add small delay to ensure state propagation
              Future.delayed(const Duration(milliseconds: 50), () {
                widget.onLoginSuccess!(
                  state.user.roleMobile,
                  state.user.email,
                  state.user.name,
                  selectedRole,
                );
              });
            }

            // If no callback provided, trigger the main app flow
            if (widget.onLoginSuccess == null) {
              // Use the same logic as the main app flow
              context.read<AppBloc>().add(
                AppLoginSuccess(
                  userRoleMobile: state.user.roleMobile,
                  userEmail: state.user.email,
                  userName: state.user.name,
                  selectedRole: selectedRole,
                ),
              );
            }
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: _LoginForm(
          formKey: _formKey,
          identifierController: _identifierController,
          passwordController: _passwordController,
          isPasswordVisible: _isPasswordVisible,
          onPasswordVisibilityChanged: (value) {
            setState(() {
              _isPasswordVisible = value;
            });
          },
          clearAllStates: _clearAllStates,
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController identifierController;
  final TextEditingController passwordController;
  final bool isPasswordVisible;
  final Function(bool) onPasswordVisibilityChanged;
  final Future<void> Function(BuildContext) clearAllStates;

  const _LoginForm({
    required this.formKey,
    required this.identifierController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.onPasswordVisibilityChanged,
    required this.clearAllStates,
  });

  @override
  Widget build(BuildContext context) {
    void login() async {
      if (formKey.currentState!.validate()) {
        // Clear all states before login attempt
        print('LoginScreen: Clearing states before login attempt');
        await clearAllStates(context);

        // Wait a bit more to ensure state clearing is complete
        await Future.delayed(const Duration(milliseconds: 200));

        // Proceed with login
        context.read<AuthBloc>().add(
          AuthLoginRequested(
            identifier: identifierController.text.trim(),
            password: passwordController.text,
          ),
        );
      }
    }

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.backgroundWhite,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    SvgPicture.asset('assets/images/LOGO-SVG.svg', height: 140),
                    const SizedBox(height: 20),
                    Text(
                      'MerahPutih',
                      style: AppText.kaiseiBold.copyWith(
                        fontSize: 32,
                        color: AppColors.primaryRed,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    TextFormField(
                      controller: identifierController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number or Username',
                        border: UnderlineInputBorder(),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.primaryRed,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number or username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const UnderlineInputBorder(),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.primaryRed,
                            width: 2,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            onPasswordVisibilityChanged(!isPasswordVisible);
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
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: AppText.kaiseiRegular.copyWith(
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: state is AuthLoading ? null : login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: state is AuthLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text('Login', style: AppText.kaiseiRegular),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
