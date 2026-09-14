import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/review_provider.dart';
import '../widgets/rating_summary_card.dart';
import '../widgets/review_card.dart';
import 'write_review_screen.dart';

class ReviewsScreen extends ConsumerWidget {
  final String serviceId;
  final String serviceName;

  const ReviewsScreen({super.key, required this.serviceId, required this.serviceName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(ratingSummaryProvider(serviceId));
    final reviews = ref.watch(filteredReviewsProvider(serviceId));
    final selectedFilter = ref.watch(reviewStarFilterProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Reviews — $serviceName')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: RatingSummaryCard(summary: summary),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _FilterChip(
                  label: 'All',
                  isSelected: selectedFilter == 0,
                  onTap: () => ref.read(reviewStarFilterProvider.notifier).state = 0,
                ),
                for (int star = 5; star >= 1; star--)
                  _FilterChip(
                    label: '$star Star${star == 1 ? '' : 's'}',
                    isSelected: selectedFilter == star,
                    onTap: () => ref.read(reviewStarFilterProvider.notifier).state = star,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: reviews.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return ReviewCard(
                  review: review,
                  onHelpfulTap: () => ref.read(allReviewsProvider.notifier).markHelpful(review.id),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => WriteReviewScreen(serviceId: serviceId, serviceName: serviceName),
          ),
        ),
        icon: const Icon(Icons.rate_review_outlined),
        label: const Text('Write a Review'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.reviews_outlined, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text('No reviews yet', style: AppTextStyles.sectionHeading),
            const SizedBox(height: 8),
            Text(
              'Be the first to share your experience.',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}