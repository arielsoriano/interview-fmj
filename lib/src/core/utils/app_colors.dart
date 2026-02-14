import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFF818CF8);

  static const Color secondary = Color(0xFF8B5CF6);
  static const Color secondaryDark = Color(0xFF7C3AED);
  static const Color secondaryLight = Color(0xFFA78BFA);

  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  static const Color divider = Color(0xFFE5E7EB);
  static const Color border = Color(0xFFD1D5DB);

  static const Color favourite = Color(0xFFEF4444);
  static const Color favouriteInactive = Color(0xFF9CA3AF);

  static const Color categoryHealthWellness = Color(0xFF10B981);
  static const Color categoryMusic = Color(0xFFEC4899);
  static const Color categoryFood = Color(0xFFF59E0B);
  static const Color categoryArt = Color(0xFF8B5CF6);
  static const Color categorySports = Color(0xFF3B82F6);
  static const Color categoryTechnology = Color(0xFF6366F1);
  static const Color categoryDefault = Color(0xFF6B7280);

  static const Color shimmerBase = Color(0xFFE5E7EB);
  static const Color shimmerHighlight = Color(0xFFF9FAFB);

  static const Color shadow = Color(0x1A000000);
  static const Color overlay = Color(0x66000000);

  static Color getCategoryColor(String category) {
    final normalizedCategory = category.toLowerCase().trim();

    if (normalizedCategory.contains('health') ||
        normalizedCategory.contains('wellness') ||
        normalizedCategory.contains('yoga')) {
      return categoryHealthWellness;
    }

    if (normalizedCategory.contains('music') ||
        normalizedCategory.contains('concert')) {
      return categoryMusic;
    }

    if (normalizedCategory.contains('food') ||
        normalizedCategory.contains('culinary')) {
      return categoryFood;
    }

    if (normalizedCategory.contains('art') ||
        normalizedCategory.contains('culture')) {
      return categoryArt;
    }

    if (normalizedCategory.contains('sport') ||
        normalizedCategory.contains('fitness')) {
      return categorySports;
    }

    if (normalizedCategory.contains('tech') ||
        normalizedCategory.contains('innovation')) {
      return categoryTechnology;
    }

    return categoryDefault;
  }
}
