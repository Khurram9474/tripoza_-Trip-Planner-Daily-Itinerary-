import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/recommendation_result.dart';

class RecommendationCard extends StatelessWidget {
  final RecommendationResult result;
  final bool isSaved;
  final VoidCallback onViewDetails;
  final VoidCallback onSaveToggle;

  const RecommendationCard({
    super.key,
    required this.result,
    required this.isSaved,
    required this.onViewDetails,
    required this.onSaveToggle,
  });

  Color get _tierColor => switch (result.tier) {
    MatchTier.best => AppColors.success,
    MatchTier.good => AppColors.primary,
    MatchTier.fair => AppColors.warning,
  };

  @override
  Widget build(BuildContext context) {
    final service = result.service;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  service.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.surfaceVariant,
                    child: const Icon(Icons.image_not_supported_outlined, color: AppColors.textSecondary, size: 40),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: _tierColor, borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    '${result.matchLabel} · ${result.matchPercent}%',
                    style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: IconButton(
                  onPressed: onSaveToggle,
                  icon: Icon(
                    isSaved ? Icons.favorite : Icons.favorite_border,
                    color: isSaved ? AppColors.error : Colors.white,
                  ),
                  style: IconButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: 0.3)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(service.name, style: AppTextStyles.cardTitle)),
                    const Icon(Icons.star, size: 14, color: AppColors.warning),
                    const SizedBox(width: 2),
                    Text(service.rating.toStringAsFixed(1), style: AppTextStyles.bodySmall),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Expanded(child: Text(service.location, style: AppTextStyles.bodySmall)),
                    Text(
                      'PKR ${_formatPrice(service.price)}',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Why it\'s recommended', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      ...result.reasons.map(
                            (reason) => Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text('• $reason', style: AppTextStyles.bodySmall),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onViewDetails,
                    child: const Text('View Details'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  }
}