import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class TripStats extends StatelessWidget {
  final int totalDays;
  final int totalActivities;
  final int travelers;

  const TripStats({
    super.key,
    required this.totalDays,
    required this.totalActivities,
    required this.travelers,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatBox(icon: Icons.calendar_month_rounded, label: 'Days', value: '$totalDays'),
        const SizedBox(width: 10),
        _StatBox(icon: Icons.checklist_rounded, label: 'Activities', value: '$totalActivities'),
        const SizedBox(width: 10),
        _StatBox(icon: Icons.people_alt_rounded, label: 'Travelers', value: '$travelers'),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatBox({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8)],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.secondary, size: 22),
            const SizedBox(height: 6),
            Text(value, style: AppTextStyles.cardTitle),
            Text(label, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}