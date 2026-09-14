import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/review_model.dart';
import 'star_rating_display.dart';

class ReviewCard extends StatelessWidget {
  final ReviewModel review;
  final VoidCallback onHelpfulTap;

  const ReviewCard({super.key, required this.review, required this.onHelpfulTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  backgroundImage: review.avatarUrl != null ? NetworkImage(review.avatarUrl!) : null,
                  child: review.avatarUrl == null
                      ? Text(
                    review.userName.isNotEmpty ? review.userName[0].toUpperCase() : '?',
                    style: AppTextStyles.cardTitle.copyWith(color: AppColors.primary),
                  )
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.userName, style: AppTextStyles.cardTitle),
                      Text(
                        DateFormat('d MMM yyyy').format(review.createdAt),
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                StarRatingDisplay(rating: review.rating.toDouble()),
              ],
            ),
            const SizedBox(height: 10),
            Text(review.reviewText, style: AppTextStyles.bodyMedium),
            if (review.imageUrl != null) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  review.imageUrl!,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 140,
                    color: AppColors.surfaceVariant,
                    child: const Icon(Icons.image_not_supported_outlined, color: AppColors.textSecondary),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 10),
            InkWell(
              onTap: onHelpfulTap,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.thumb_up_outlined, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text('Helpful — ${review.helpfulCount}', style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}