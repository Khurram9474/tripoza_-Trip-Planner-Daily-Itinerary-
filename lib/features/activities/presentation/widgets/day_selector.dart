import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class DaySelector extends StatelessWidget {
  final int totalDays;
  final int selectedDay;
  final ValueChanged<int> onSelected;

  const DaySelector({
    super.key,
    required this.totalDays,
    required this.selectedDay,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: totalDays,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final day = index + 1;
          final isSelected = day == selectedDay;
          return GestureDetector(
            onTap: () => onSelected(day),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 6)],
              ),
              child: Center(
                child: Text(
                  'Day $day',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}