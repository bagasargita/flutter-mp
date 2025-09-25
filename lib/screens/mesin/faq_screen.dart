import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:merah_putih/core/api/api_client.dart';
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
  final ApiClient _api = ApiClient.create();
  bool _loadingCategories = false;
  final List<String> _categories = [];
  final Map<String, List<FAQItem>> _categoryItemsCache = {};
  final Set<String> _loadingCategoryItems = {};
  String? _selectedCategory;
  bool _loadingItems = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
    _fetchCategories();
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 6),
              ),
              style: AppText.kaiseiRegular.copyWith(
                fontSize: 14,
                color: AppColors.textBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFAQCategories() {
    if (_loadingCategories && _categories.isEmpty) {
      return [const Center(child: CircularProgressIndicator())];
    }

    final List<String> visibleCategories = _categories.where((c) {
      if (_searchQuery.isEmpty) return true;
      final items = _categoryItemsCache[c];
      if (items == null) {
        return c.toLowerCase().contains(_searchQuery);
      }
      final hasMatchInItems = items.any(
        (i) =>
            i.question.toLowerCase().contains(_searchQuery) ||
            i.answer.toLowerCase().contains(_searchQuery),
      );
      return c.toLowerCase().contains(_searchQuery) || hasMatchInItems;
    }).toList();

    if (visibleCategories.isEmpty) {
      return [const SizedBox.shrink()];
    }

    return visibleCategories.map((categoryTitle) {
      final items = _categoryItemsCache[categoryTitle] ?? [];
      final isLoadingItems = _loadingCategoryItems.contains(categoryTitle);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () async {
              final expanded = _expandedItems[categoryTitle] ?? false;
              setState(() {
                _expandedItems[categoryTitle] = !expanded;
              });
              if (!expanded &&
                  !_categoryItemsCache.containsKey(categoryTitle)) {
                await _fetchFaqByCategory(categoryTitle);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  categoryTitle,
                  style: AppText.kaiseiRegular.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
                Icon(
                  (_expandedItems[categoryTitle] ?? false)
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if ((_expandedItems[categoryTitle] ?? false)) ...[
            if (isLoadingItems)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Center(child: CircularProgressIndicator()),
              )
            else
              ...items.map((item) => _buildFAQItem(item)),
          ],
          const SizedBox(height: 16),
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
            dense: true,
            title: Text(
              item.question,
              style: AppText.kaiseiRegular.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textBlack,
              ),
            ),
            trailing: Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.grey[600],
              size: 20,
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
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: Text(
                item.answer,
                style: AppText.kaiseiRegular.copyWith(
                  fontSize: 13,
                  color: AppColors.textGray,
                  height: 1.8,
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

  Future<void> _fetchCategories() async {
    setState(() {
      _loadingCategories = true;
    });
    try {
      final response = await _api.getFaqCategories();
      final data = response.data;
      if (data != null && data['data'] is List) {
        final List<dynamic> raw = data['data'] as List<dynamic>;
        _categories
          ..clear()
          ..addAll(raw.map((e) => e.toString()));
        if (_categories.isNotEmpty) {
          _selectedCategory = _categories.first;
        }
      }
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() {
          _loadingCategories = false;
        });
      }
    }
    if (_selectedCategory != null &&
        !_categoryItemsCache.containsKey(_selectedCategory!)) {
      await _fetchFaqByCategory(_selectedCategory!);
    }
  }

  Future<void> _fetchFaqByCategory(String category) async {
    if (_loadingCategoryItems.contains(category)) return;
    setState(() {
      _loadingCategoryItems.add(category);
      if (category == _selectedCategory) {
        _loadingItems = true;
      }
    });
    try {
      final response = await _api.getFaqByCategory(kategori: category);
      final data = response.data;
      if (data != null && data['data'] is List) {
        final List<dynamic> raw = data['data'] as List<dynamic>;
        final items = raw.map((e) {
          final map = e as Map<String, dynamic>;
          final subject = map['subject']?.toString() ?? '';
          final desc = map['desc']?.toString() ?? '';
          return FAQItem(question: subject, answer: desc);
        }).toList();
        _categoryItemsCache[category] = items;
      }
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() {
          _loadingCategoryItems.remove(category);
          if (category == _selectedCategory) {
            _loadingItems = false;
          }
        });
      }
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
