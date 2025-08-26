import 'package:flutter/material.dart';
import 'package:smart_mob/constants/app_colors.dart';
import 'package:smart_mob/constants/app_text.dart';
import 'package:smart_mob/widgets/common/app_top_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class SetorTunaiHelpScreen extends StatefulWidget {
  const SetorTunaiHelpScreen({super.key});

  @override
  State<SetorTunaiHelpScreen> createState() => _SetorTunaiHelpScreenState();
}

class _SetorTunaiHelpScreenState extends State<SetorTunaiHelpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _transactionNumberController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedComplaintType;

  final List<String> _complaintTypes = [
    'Masalah Teknis',
    'Transaksi Gagal',
    'Saldo Tidak Masuk',
    'Mesin Rusak',
    'Lainnya',
  ];

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
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
    );
  }

  Widget _buildComplaintSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ajukan Keluhan',
          style: AppText.heading3.copyWith(
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
        const SizedBox(height: 16),

        _buildInputField(
          controller: _transactionNumberController,
          hintText: 'Nomor Transaksi (opsional)',
          icon: Icons.receipt_outlined,
        ),
        const SizedBox(height: 16),

        _buildDropdownField(),
        const SizedBox(height: 16),

        Text(
          'Deskripsi Keluhan Anda',
          style: AppText.bodyMedium.copyWith(
            color: AppColors.textBlack,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),

        _buildTextArea(),
        const SizedBox(height: 16),

        _buildAttachmentButton(),
        const SizedBox(height: 24),

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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(Icons.category_outlined, color: Colors.grey[600], size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedComplaintType ?? 'Jenis Keluhan',
                style: TextStyle(
                  color: _selectedComplaintType != null
                      ? AppColors.textBlack
                      : Colors.grey[500],
                  fontSize: 14,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: Colors.grey[600], size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          TextField(
            controller: _descriptionController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Ketik pesan Anda di sini..',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(Icons.attach_file, color: Colors.grey[600], size: 20),
            const SizedBox(width: 12),
            Text(
              'Tambahkan Lampiran',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Icon(Icons.keyboard_arrow_right, color: Colors.grey[600], size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitComplaint,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          'Kirim',
          style: AppText.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
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
          style: AppText.heading3.copyWith(
            color: AppColors.textBlack,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),

        GestureDetector(
          onTap: _openWhatsApp,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFF25D366),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.message,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'WhatsApp',
                  style: TextStyle(
                    color: AppColors.textBlack,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  '+62 812-3456-7890',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
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
                      style: AppText.bodyLarge.copyWith(
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
          style: AppText.bodyMedium.copyWith(
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

  void _submitComplaint() {
    if (_nameController.text.isEmpty) {
      _showErrorDialog('Nama harus diisi');
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
      _transactionNumberController.clear();
      _descriptionController.clear();
      _selectedComplaintType = null;
    });
  }

  void _openWhatsApp() async {
    const phoneNumber = '+6281234567890';
    const message = 'Halo, saya ingin bertanya tentang layanan SmartMob';
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
