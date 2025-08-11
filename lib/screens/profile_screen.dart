import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Jhon');
  final _emailController = TextEditingController(text: 'jhondoe@gmail.com');
  final _phoneController = TextEditingController(text: '+62 896-1234-1234');
  final _passwordController = TextEditingController(text: '••••••••');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
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
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
              size: 24,
              color: AppColors.textBlack,
            ),
          ),
          const Expanded(
            child: Text(
              'Profile',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
              textAlign: TextAlign.center,
              textScaler: TextScaler.linear(1.0),
            ),
          ),
          Stack(
            children: [
              const Icon(
                Icons.notifications,
                size: 24,
                color: AppColors.textBlack,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryRed,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
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
              backgroundImage: const AssetImage('assets/images/profile.png'),
              onBackgroundImageError: (exception, stackTrace) {
                // Handle error if image fails to load
              },
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
        const Text(
          'Jhon Doe',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryRed,
          ),
          textScaler: TextScaler.linear(1.0),
        ),
        const SizedBox(height: 4),
        const Text(
          'WSMM Pondok Pinang',
          style: TextStyle(fontSize: 16, color: AppColors.textGray),
          textScaler: TextScaler.linear(1.0),
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
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
        labelStyle: const TextStyle(color: AppColors.textGray),
      ),
      style: const TextStyle(color: AppColors.textBlack, fontSize: 16),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Handle save logic
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully'),
                backgroundColor: AppColors.primaryRed,
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          'Simpan',
          style: AppText.buttonPrimary,
          textScaler: TextScaler.linear(1.0),
        ),
      ),
    );
  }
}
