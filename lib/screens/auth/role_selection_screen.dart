import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../auth/login_screen.dart';
import '../home_screen.dart';
import '../../main.dart';

class RoleSelectionScreen extends StatefulWidget {
  final String userEmail;
  final String userName;
  final String userRoleMobile;
  final String selectedRole;
  const RoleSelectionScreen({
    super.key,
    required this.userEmail,
    required this.userName,
    required this.userRoleMobile,
    required this.selectedRole,
  });

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? _selectedRole;

  @override
  void initState() {
    super.initState();
    // If selectedRole is provided and not empty, use it
    if (widget.selectedRole.isNotEmpty) {
      _selectedRole = widget.selectedRole;
    } else if (widget.userRoleMobile == 'NON_MESIN' ||
        widget.userRoleMobile == 'MESIN') {
      _selectedRole = widget.userRoleMobile;
    } else {
      _selectedRole = 'CUSTOMER';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  // Go back to login screen
                  clearAuthState(context);
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                },
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.textBlack,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SvgPicture.asset('assets/images/LOGO-SVG.svg', height: 120),
              const SizedBox(height: 20),
              Text(
                'MerahPutih',
                style: AppText.kaiseiBold.copyWith(
                  fontSize: 32,
                  color: AppColors.primaryRed,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              _buildRoleCard(
                title: 'Pelanggan',
                subtitle: 'Masuk sebagai Pelanggan',
                icon: Icons.person,
                role: 'CUSTOMER',
                isSelected: _selectedRole == 'CUSTOMER',
                onTap: () => setState(() => _selectedRole = 'CUSTOMER'),
              ),
              const SizedBox(height: 16),
              if (widget.userRoleMobile == 'NON_MESIN')
                _buildRoleCard(
                  title: 'Penyedia Layanan Non Mesin',
                  subtitle: 'Masuk sebagai Penyedia Layanan Non Mesin',
                  icon: Icons.business,
                  role: 'NON_MESIN',
                  isSelected: _selectedRole == 'NON_MESIN',
                  onTap: () => setState(() => _selectedRole = 'NON_MESIN'),
                ),
              if (widget.userRoleMobile == 'MESIN')
                _buildRoleCard(
                  title: 'Penyedia Layanan Mesin',
                  subtitle: 'Masuk sebagai Penyedia Jasa Mesin',
                  icon: Icons.camera_alt,
                  role: 'MESIN',
                  isSelected: _selectedRole == 'MESIN',
                  onTap: () => setState(() => _selectedRole = 'MESIN'),
                ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedRole != null ? _continue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Lanjut',
                    style: AppText.kaiseiRegular.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String role,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryRed.withOpacity(0.1)
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryRed : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryRed : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.textGray,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppText.kaiseiRegular.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.primaryRed
                          : AppColors.textBlack,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppText.kaiseiRegular.copyWith(
                      color: isSelected
                          ? AppColors.primaryRed
                          : AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primaryRed,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  void _continue() {
    if (_selectedRole != null) {
      // All roles go to HomeScreen directly (no more _HomeWithNavigation)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => HomeBloc(),
            child: HomeScreen(
              userRoleMobile: widget.userRoleMobile,
              userEmail: widget.userEmail,
              userName: widget.userName,
              selectedRole: _selectedRole!,
            ),
          ),
        ),
      );
    }
  }
}
