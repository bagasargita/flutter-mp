import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text.dart';
import '../../widgets/common/app_top_bar.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _transactionController = TextEditingController();
  final _terminalController = TextEditingController();
  final _complaintController = TextEditingController();
  final _messageController = TextEditingController();
  String? _selectedComplaintType;

  final List<String> _complaintTypes = [
    'Technical Issue',
    'Payment Problem',
    'Account Issue',
    'Service Complaint',
    'Other',
  ];

  @override
  void dispose() {
    _transactionController.dispose();
    _terminalController.dispose();
    _complaintController.dispose();
    _messageController.dispose();
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
              const AppTopBar(title: 'Bantuan', showBack: true),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailSection(),
                        const SizedBox(height: 24),
                        _buildComplaintSection(),
                        const SizedBox(height: 32),
                        _buildSendButton(),
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

  Widget _buildDetailSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detail',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
          textScaler: TextScaler.linear(1.0),
        ),
        const SizedBox(height: 16),
        _buildFormField(
          controller: _transactionController,
          label: 'No transaksi',
          icon: Icons.receipt,
        ),
        const SizedBox(height: 16),
        _buildFormField(
          controller: _terminalController,
          label: 'Terminal Id',
          icon: Icons.devices,
        ),
        const SizedBox(height: 16),
        _buildDropdownField(),
      ],
    );
  }

  Widget _buildComplaintSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Masukkan Keluhan Anda',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
          textScaler: TextScaler.linear(1.0),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextFormField(
            controller: _messageController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Ketik pesan Anda di sini.',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              hintStyle: TextStyle(color: AppColors.textGray),
            ),
            style: const TextStyle(color: AppColors.textBlack, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
        labelStyle: const TextStyle(color: AppColors.textGray),
      ),
      style: const TextStyle(color: AppColors.textBlack, fontSize: 16),
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _selectedComplaintType,
      decoration: const InputDecoration(
        labelText: 'Keluhan (DROP DOW)',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.report),
        labelStyle: TextStyle(color: AppColors.textGray),
      ),
      style: const TextStyle(color: AppColors.textBlack, fontSize: 16),
      items: _complaintTypes.map((String type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(type, textScaler: TextScaler.linear(1.0)),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedComplaintType = newValue;
        });
      },
    );
  }

  Widget _buildSendButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Handle send logic
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Report sent successfully'),
                backgroundColor: AppColors.primaryRed,
              ),
            );
            Navigator.pop(context);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          'Kirim',
          style: AppText.buttonPrimary,
          textScaler: TextScaler.linear(1.0),
        ),
      ),
    );
  }
}
