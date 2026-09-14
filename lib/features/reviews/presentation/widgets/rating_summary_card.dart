import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/review_provider.dart';
import 'star_rating_display.dart';

class RatingSummaryCard extends StatelessWidget {
  final RatingSummary summary;

  const RatingSummaryCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  summary.average.toStringAsFixed(1),
                  style: AppTextStyles.displayLarge.copyWith(fontSize: 36),
                ),
                StarRatingDisplay(rating: summary.average, size: 18),
                const SizedBox(height: 4),
                Text('${summary.total} reviews', style: AppTextStyles.caption),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                children: List.generate(5, (index) {
                  final star = 5 - index;
                  final count = summary.distribution[star] ?? 0;
                  final ratio = summary.total == 0 ? 0.0 : count / summary.total;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        Text('$star', style: AppTextStyles.caption),
                        const SizedBox(width: 4),
                        const Icon(Icons.star, size: 12, color: AppColors.warning),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: ratio,
                              minHeight: 6,
                              backgroundColor: AppColors.divider,
                              valueColor: const AlwaysStoppedAnimation(AppColors.warning),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(width: 24, child: Text('$count', style: AppTextStyles.caption)),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}