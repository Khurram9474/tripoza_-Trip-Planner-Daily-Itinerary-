import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Central place mapping each activity category to its icon + color.
/// Reused by CategoryChip, ActivityCard, and the Add/Edit Activity forms.
class CategoryStyle {
  CategoryStyle._();

  static IconData icon(String category) {
    switch (category) {
      case 'Sightseeing':
        return Icons.location_on_rounded;
      case 'Food':
        return Icons.restaurant_rounded;
      case 'Adventure':
        return Icons.hiking_rounded;
      case 'Shopping':
        return Icons.shopping_bag_rounded;
      case 'Culture':
        return Icons.museum_rounded;
      case 'Entertainment':
        return Icons.celebration_rounded;
      default:
        return Icons.place_rounded;
    }
  }

  static Color color(String category) {
    switch (category) {
      case 'Sightseeing':
        return AppColors.sightseeing;
      case 'Food':
        return AppColors.food;
      case 'Adventure':
        return AppColors.adventure;
      case 'Shopping':
        return AppColors.shopping;
      case 'Culture':
        return AppColors.culture;
      case 'Entertainment':
        return AppColors.entertainment;
      default:
        return AppColors.textSecondary;
    }
  }
}

class CategoryChip extends StatelessWidget {
  final String category;
  final bool selected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.category,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = CategoryStyle.color(category);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.15) : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
          border: selected ? Border.all(color: color, width: 1.2) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CategoryStyle.icon(category), size: 16, color: color),
            const SizedBox(width: 6),
            Text(category, style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}