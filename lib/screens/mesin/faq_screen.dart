import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text.dart';
import '../../widgets/common/app_top_bar.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Map<String, bool> _expandedItems = {};

  final List<FAQCategory> _faqCategories = [
    FAQCategory(
      title: 'General',
      items: [
        FAQItem(
          question: 'What is MerahPutih?',
          answer:
              'MerahPutih is a comprehensive digital platform that provides various financial services including cash deposits, money transfers, bill payments, and more. Our platform is designed to make financial transactions easier and more accessible for everyone.',
        ),
        FAQItem(
          question: 'How do I create an account?',
          answer:
              'To create an account, simply download our app from the App Store or Google Play Store, then follow the registration process. You\'ll need to provide your personal information, verify your identity, and set up your security credentials.',
        ),
        FAQItem(
          question: 'Is my data secure?',
          answer:
              'Yes, we take data security very seriously. We use industry-standard encryption protocols, secure servers, and comply with all relevant data protection regulations to ensure your personal and financial information is always protected.',
        ),
      ],
    ),
    FAQCategory(
      title: 'Account',
      items: [
        FAQItem(
          question: 'How do I reset my password?',
          answer:
              'To reset your password, go to the login screen and tap "Forgot Password". Enter your registered email address, and we\'ll send you a secure link to reset your password. Follow the instructions in the email to create a new password.',
        ),
        FAQItem(
          question: 'Can I change my username?',
          answer:
              'Yes, you can change your username by going to your profile settings. However, please note that username changes may be subject to availability and certain restrictions. Contact our support team if you need assistance.',
        ),
        FAQItem(
          question: 'How do I delete my account?',
          answer:
              'To delete your account, please contact our customer support team through the app or WhatsApp. We\'ll guide you through the process and ensure all your data is properly removed from our systems.',
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: const TextScaler.linear(1.0)),
        child: SafeArea(
          child: Column(
            children: [
              AppTopBar(title: 'FAQ', showBack: Navigator.of(context).canPop()),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearchBar(),
                      const SizedBox(height: 24),
                      ..._buildFAQCategories(),
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

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey[600], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search FAQs',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: AppText.kaiseiRegular.copyWith(
                fontSize: 16,
                color: AppColors.textBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFAQCategories() {
    return _faqCategories.map((category) {
      final filteredItems = category.items.where((item) {
        if (_searchQuery.isEmpty) return true;
        return item.question.toLowerCase().contains(_searchQuery) ||
            item.answer.toLowerCase().contains(_searchQuery);
      }).toList();

      if (filteredItems.isEmpty && _searchQuery.isNotEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category.title,
            style: AppText.kaiseiRegular.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 16),
          ...filteredItems.map((item) => _buildFAQItem(item)),
          const SizedBox(height: 24),
        ],
      );
    }).toList();
  }

  Widget _buildFAQItem(FAQItem item) {
    final isExpanded = _expandedItems[item.question] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              item.question,
              style: AppText.kaiseiRegular.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textBlack,
              ),
            ),
            trailing: Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.grey[600],
            ),
            onTap: () {
              setState(() {
                _expandedItems[item.question] = !isExpanded;
              });
            },
          ),
          if (isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                item.answer,
                style: AppText.kaiseiRegular.copyWith(
                  fontSize: 14,
                  color: AppColors.textGray,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hubungi Kami',
          style: AppText.kaiseiRegular.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: _openWhatsApp,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF25D366),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.chat, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WhatsApp',
                        style: AppText.kaiseiRegular.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '+62 812-3456-7890',
                        style: AppText.kaiseiRegular.copyWith(
                          fontSize: 14,
                          color: AppColors.textGray,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[600],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _openWhatsApp() async {
    const phoneNumber = '+6281234567890';
    const message = 'Hello, I need help with MerahPutih app.';
    final url =
        'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open WhatsApp'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error opening WhatsApp'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class FAQCategory {
  final String title;
  final List<FAQItem> items;

  FAQCategory({required this.title, required this.items});
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}
