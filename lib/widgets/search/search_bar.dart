import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class SearchInputBar extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final VoidCallback? onClear;
  final ValueChanged<String>? onChanged;

  const SearchInputBar({
    super.key,
    this.hintText = 'Cari',
    this.controller,
    this.onClear,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.textGray),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                hintStyle: const TextStyle(color: AppColors.textGray),
              ),
            ),
          ),
          if (onClear != null)
            GestureDetector(
              onTap: onClear,
              child: Icon(Icons.close, color: AppColors.textGray),
            ),
        ],
      ),
    );
  }
}
