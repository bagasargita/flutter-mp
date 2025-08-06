import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppText {
  // Amaranth Font Styles (for Headers/Titles)
  static const TextStyle amaranthRegular = TextStyle(
    fontFamily: 'Amaranth',
    fontWeight: FontWeight.w400,
  );

  static const TextStyle amaranthBold = TextStyle(
    fontFamily: 'Amaranth',
    fontWeight: FontWeight.w700,
  );

  static const TextStyle amaranthItalic = TextStyle(
    fontFamily: 'Amaranth',
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
  );

  // Kaisei Tokumin Font Styles (for Body/Descriptions)
  static const TextStyle kaiseiRegular = TextStyle(
    fontFamily: 'Kaisei Tokumin',
    fontWeight: FontWeight.w400,
  );

  static const TextStyle kaiseiMedium = TextStyle(
    fontFamily: 'Kaisei Tokumin',
    fontWeight: FontWeight.w500,
  );

  static const TextStyle kaiseiBold = TextStyle(
    fontFamily: 'Kaisei Tokumin',
    fontWeight: FontWeight.w700,
  );

  static const TextStyle kalamBold = TextStyle(
    fontFamily: 'Kalam',
    fontWeight: FontWeight.w700,
    fontSize: 24,
  );

  static const TextStyle kalamBoldLarge = TextStyle(
    fontFamily: 'Kalam',
    fontWeight: FontWeight.w700,
    fontSize: 32,
    color: AppColors.primaryRed,
  );

  static const TextStyle kalamMediumItalic = TextStyle(
    fontFamily: 'Kalam',
    fontWeight: FontWeight.w500,
    fontSize: 24,
    fontStyle: FontStyle.italic,
    color: AppColors.primaryRed,
  );

  static const TextStyle kalamRegular = TextStyle(
    fontFamily: 'Kalam',
    fontWeight: FontWeight.w400,
  );

  // Heading Styles (Amaranth)
  static const TextStyle heading1 = TextStyle(
    fontFamily: 'Amaranth',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textBlack,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: 'Amaranth',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textBlack,
  );

  static const TextStyle heading3 = TextStyle(
    fontFamily: 'Amaranth',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textBlack,
  );

  static const TextStyle heading4 = TextStyle(
    fontFamily: 'Amaranth',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textBlack,
  );

  // Body Styles (Kaisei Tokumin)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Kaisei Tokumin',
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.textBlack,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Kaisei Tokumin',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textBlack,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Kaisei Tokumin',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textGray,
  );

  // Button Styles (Amaranth)
  static const TextStyle buttonPrimary = TextStyle(
    fontFamily: 'Amaranth',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static const TextStyle buttonSecondary = TextStyle(
    fontFamily: 'Amaranth',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryRed,
  );

  // Label Styles (Kaisei Tokumin)
  static const TextStyle labelMedium = TextStyle(
    fontFamily: 'Kaisei Tokumin',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textGray,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: 'Kaisei Tokumin',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textGray,
  );

  // Caption Styles (Kaisei Tokumin)
  static const TextStyle caption = TextStyle(
    fontFamily: 'Kaisei Tokumin',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textLightGray,
  );

  // Description Styles (Kaisei Tokumin)
  static const TextStyle description = TextStyle(
    fontFamily: 'Kaisei Tokumin',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textGray,
    height: 1.5,
  );

  static const TextStyle descriptionSmall = TextStyle(
    fontFamily: 'Kaisei Tokumin',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textGray,
    height: 1.4,
  );
}
