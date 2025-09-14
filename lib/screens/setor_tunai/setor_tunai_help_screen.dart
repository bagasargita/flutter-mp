import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merah_putih/constants/app_colors.dart';
import 'package:merah_putih/constants/app_text.dart';
import 'package:merah_putih/widgets/common/app_top_bar.dart';
import 'package:merah_putih/core/api/api_client.dart';
import 'package:merah_putih/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:merah_putih/features/auth/domain/entities/user.dart';
import 'package:url_launcher/url_launcher.dart';

class SetorTunaiHelpScreen extends StatefulWidget {
  const SetorTunaiHelpScreen({super.key});

  @override
  State<SetorTunaiHelpScreen> createState() => _SetorTunaiHelpScreenState();
}

class _SetorTunaiHelpScreenState extends State<SetorTunaiHelpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _transactionNumberController =
      TextEditingController();
  final TextEditingController _machineController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedComplaintType;
  bool _isSubmitting = false;

  final List<String> _complaintTypes = [
    'Masalah Teknis',
    'Transaksi Gagal',
    'Saldo Tidak Masuk',
    'Mesin Rusak',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(const AuthCheckRequested());
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _transactionNumberController.dispose();
    _machineController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateControllers(User user) {
    _nameController.text = user.name;
    _emailController.text = user.email;
    _phoneController.text = user.phoneNumber ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          _updateControllers(state.user);
        }
      },
      child: MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(1.0)),
        child: Scaffold(
          backgroundColor: AppColors.backgroundWhite,
          body: SafeArea(
            child: Column(
              children: [
                const AppTopBar(title: 'Bantuan', showBack: true),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildComplaintSection(),
                        const SizedBox(height: 32),
                        _buildContactSection(),
                      ],
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

  Widget _buildComplaintSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ajukan Keluhan',
          style: AppText.kaiseiBold.copyWith(
            color: AppColors.textBlack,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 24),

        _buildInputField(
          controller: _nameController,
          hintText: 'Nama',
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 20),

        _buildInputField(
          controller: _emailController,
          hintText: 'Email',
          icon: Icons.email_outlined,
        ),
        const SizedBox(height: 20),

        _buildInputField(
          controller: _phoneController,
          hintText: 'Nomor Telepon',
          icon: Icons.phone_outlined,
        ),
        const SizedBox(height: 20),

        _buildInputField(
          controller: _transactionNumberController,
          hintText: 'Nomor Transaksi (opsional)',
          icon: Icons.receipt_outlined,
        ),
        const SizedBox(height: 20),

        _buildInputField(
          controller: _machineController,
          hintText: 'Mesin (opsional)',
          icon: Icons.devices_outlined,
        ),
        const SizedBox(height: 20),

        _buildDropdownField(),
        const SizedBox(height: 20),

        Text(
          'Deskripsi Keluhan Anda',
          style: AppText.kaiseiRegular.copyWith(
            color: AppColors.textBlack,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),

        _buildTextArea(),
        const SizedBox(height: 20),

        _buildAttachmentButton(),
        const SizedBox(height: 32),

        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
  }) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: controller,
              style: AppText.kaiseiRegular.copyWith(
                color: AppColors.textBlack,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                hintStyle: AppText.kaiseiRegular.copyWith(
                  color: Colors.grey[500],
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField() {
    return GestureDetector(
      onTap: _showComplaintTypeDialog,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.category_outlined, color: Colors.grey[600], size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                _selectedComplaintType ?? 'Jenis Keluhan',
                style: AppText.kaiseiRegular.copyWith(
                  color: _selectedComplaintType != null
                      ? AppColors.textBlack
                      : Colors.grey[500],
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: Colors.grey[600], size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildTextArea() {
    return Container(
      constraints: const BoxConstraints(minHeight: 120),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: _descriptionController,
            maxLines: 5,
            minLines: 4,
            style: AppText.kaiseiRegular.copyWith(
              color: AppColors.textBlack,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              hintText: 'Ketik pesan Anda di sini..',
              border: InputBorder.none,
              hintStyle: AppText.kaiseiRegular.copyWith(
                color: Colors.grey[500],
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.drag_handle, color: Colors.grey[400], size: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentButton() {
    return GestureDetector(
      onTap: _addAttachment,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.attach_file, color: Colors.grey[600], size: 22),
            const SizedBox(width: 16),
            Text(
              'Tambahkan Lampiran',
              style: AppText.kaiseiRegular.copyWith(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Icon(Icons.keyboard_arrow_right, color: Colors.grey[600], size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitComplaint,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          shadowColor: AppColors.primaryRed.withOpacity(0.3),
        ),
        child: _isSubmitting
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                'Kirim',
                style: AppText.kaiseiRegular.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
      ),
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hubungi Kami',
          style: AppText.kaiseiBold.copyWith(
            color: AppColors.textBlack,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),

        GestureDetector(
          onTap: _openWhatsApp,
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/whatsapp.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'WhatsApp',
                  style: AppText.kaiseiRegular.copyWith(
                    color: AppColors.textBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  '+62 812-3456-7890',
                  style: AppText.kaiseiRegular.copyWith(
                    color: Colors.grey[600],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showComplaintTypeDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      'Pilih Jenis Keluhan',
                      style: AppText.kaiseiRegular.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlack,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._complaintTypes.map(
                      (type) => _buildComplaintTypeOption(type),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComplaintTypeOption(String type) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedComplaintType = type;
        });
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Text(
          type,
          style: AppText.kaiseiRegular.copyWith(
            color: AppColors.textBlack,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _addAttachment() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambahkan Lampiran'),
        content: const Text('Fitur lampiran akan segera hadir'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _submitComplaint() async {
    if (_nameController.text.isEmpty) {
      _showErrorDialog('Nama harus diisi');
      return;
    }

    if (_emailController.text.isEmpty) {
      _showErrorDialog('Email harus diisi');
      return;
    }

    if (_phoneController.text.isEmpty) {
      _showErrorDialog('Nomor telepon harus diisi');
      return;
    }

    if (_selectedComplaintType == null) {
      _showErrorDialog('Jenis keluhan harus dipilih');
      return;
    }

    if (_descriptionController.text.isEmpty) {
      _showErrorDialog('Deskripsi keluhan harus diisi');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final apiClient = ApiClient.create();
      await apiClient.createSupportTicket(
        name: _nameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        transactionNumber: _transactionNumberController.text,
        machine: _machineController.text.isNotEmpty
            ? _machineController.text
            : null,
        subject: _selectedComplaintType!,
        message: _descriptionController.text,
      );

      setState(() {
        _isSubmitting = false;
      });

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Keluhan Terkirim'),
            content: const Text(
              'Terima kasih atas keluhan Anda. Tim kami akan segera menghubungi Anda.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _clearForm();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });

      _showErrorDialog('Gagal mengirim keluhan. Silakan coba lagi.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _clearForm() {
    setState(() {
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _transactionNumberController.clear();
      _machineController.clear();
      _descriptionController.clear();
      _selectedComplaintType = null;
    });
  }

  void _openWhatsApp() async {
    const phoneNumber = '+6281234567890';
    const message = 'Halo, saya ingin bertanya tentang layanan MerahPutih';
    final url =
        'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';

    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorDialog('Tidak dapat membuka WhatsApp');
      }
    } catch (e) {
      _showErrorDialog('Terjadi kesalahan saat membuka WhatsApp');
    }
  }
}
