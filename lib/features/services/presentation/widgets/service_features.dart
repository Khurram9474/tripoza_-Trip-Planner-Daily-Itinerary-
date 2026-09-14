import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ServiceFeatures extends StatelessWidget {
  final List<String> features;

  const ServiceFeatures({super.key, required this.features});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: features.map((feature) {
        return Chip(
          avatar: const Icon(Icons.check_circle, size: 16, color: AppColors.success),
          label: Text(feature, style: AppTextStyles.bodySmall),
          backgroundColor: AppColors.surfaceVariant,
          side: BorderSide.none,
        );
      }).toList(),
    );
  }
}