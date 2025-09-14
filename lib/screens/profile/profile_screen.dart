import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text.dart';
import '../../widgets/common/app_top_bar.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/domain/entities/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController(text: '••••••••');

    // Check for current user data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(const AuthCheckRequested());
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _updateControllers(User user) {
    _nameController.text = user.name;
    _emailController.text = user.email;
    _phoneController.text = user.phoneNumber ?? '';
    _currentUser = user;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          _updateControllers(state.user);
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated && _currentUser == null) {
            _updateControllers(state.user);
          }

          if (state is AuthLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is AuthUnauthenticated) {
            return const Scaffold(
              body: Center(child: Text('Please log in to view your profile')),
            );
          }

          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(1.0)),
            child: Scaffold(
              backgroundColor: AppColors.backgroundWhite,
              body: SafeArea(
                child: Column(
                  children: [
                    const AppTopBar(title: 'Profile', showBack: true),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildProfileSection(),
                              const SizedBox(height: 32),
                              _buildFormFields(),
                              const SizedBox(height: 32),
                              _buildSaveButton(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _currentUser?.profilePicture != null
                  ? NetworkImage(_currentUser!.profilePicture!)
                  : const AssetImage('assets/images/profile.png')
                        as ImageProvider,
              onBackgroundImageError: (exception, stackTrace) {},
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.primaryRed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.error, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          _currentUser?.name ?? 'Loading...',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryRed,
          ),
          textScaler: TextScaler.linear(1.0),
        ),
        const SizedBox(height: 4),
        Text(
          _currentUser?.customer ?? 'Loading...',
          style: const TextStyle(fontSize: 16, color: AppColors.textGray),
          textScaler: TextScaler.linear(1.0),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primaryRed.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primaryRed.withOpacity(0.3)),
          ),
          child: Text(
            _currentUser?.roleMobile ?? 'Loading...',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.primaryRed,
              fontWeight: FontWeight.w600,
            ),
            textScaler: TextScaler.linear(1.0),
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        _buildFormField(
          controller: _nameController,
          label: 'Nama',
          icon: Icons.person,
        ),
        const SizedBox(height: 16),
        _buildFormField(
          controller: _emailController,
          label: 'Email',
          icon: Icons.email,
        ),
        const SizedBox(height: 16),
        _buildFormField(
          controller: _phoneController,
          label: 'No Handphone',
          icon: Icons.phone,
        ),
        const SizedBox(height: 16),
        _buildFormField(
          controller: _passwordController,
          label: 'Password',
          icon: Icons.lock,
          isPassword: true,
        ),
        const SizedBox(height: 16),
        _buildRoleField(),
      ],
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      enabled: !isPassword,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
        labelStyle: const TextStyle(color: AppColors.textGray),
      ),
      style: const TextStyle(color: AppColors.textBlack, fontSize: 16),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildRoleField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.textGray.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.work, color: AppColors.textGray, size: 20),
          const SizedBox(width: 12),
          const Text(
            'Role:',
            style: TextStyle(color: AppColors.textGray, fontSize: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _currentUser?.roleMobile ?? 'Loading...',
              style: const TextStyle(
                color: AppColors.primaryRed,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (_currentUser != null) {
              final updatedUser = _currentUser!.copyWith(
                name: _nameController.text,
                email: _emailController.text,
                phoneNumber: _phoneController.text,
              );

              context.read<AuthBloc>().add(AuthUpdateProfile(updatedUser));

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated successfully'),
                  backgroundColor: AppColors.primaryRed,
                ),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          'Update Profile',
          style: AppText.kaiseiRegular.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          textScaler: TextScaler.linear(1.0),
        ),
      ),
    );
  }
}
