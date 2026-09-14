import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tripora/features/services/presentation/providers/service_provider.dart';
import 'package:tripora/features/services/presentation/widgets/service_features.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../reviews/presentation/providers/review_provider.dart';
import '../../../reviews/presentation/widgets/rating_summary_card.dart';
import '../../../reviews/presentation/widgets/review_card.dart';
import '../../../reviews/presentation/pages/reviews_screen.dart';
import '../../../reviews/presentation/pages/write_review_screen.dart';

class ServiceDetailsScreen extends ConsumerWidget {
  final String serviceId;

  const ServiceDetailsScreen({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(serviceByIdProvider(serviceId));

    if (service == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text('This service is no longer available.', style: AppTextStyles.bodyMedium),
        ),
      );
    }

    final ratingSummary = ref.watch(ratingSummaryProvider(serviceId));
    final topReviews = ref.watch(reviewsForServiceProvider(serviceId)).take(2).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.surface,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                service.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.surfaceVariant,
                  child: const Icon(Icons.image_not_supported_outlined, size: 48, color: AppColors.textSecondary),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service.name, style: AppTextStyles.screenTitle),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(service.location, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                      const SizedBox(width: 16),
                      const Icon(Icons.star, size: 16, color: AppColors.warning),
                      const SizedBox(width: 4),
                      Text(service.rating.toStringAsFixed(1), style: AppTextStyles.bodyMedium),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      service.category,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('About', style: AppTextStyles.sectionHeading),
                  const SizedBox(height: 8),
                  Text(service.description, style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 20),
                  Text('Features', style: AppTextStyles.sectionHeading),
                  const SizedBox(height: 10),
                  ServiceFeatures(features: service.features),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(
                        service.isAvailable ? Icons.check_circle : Icons.cancel,
                        size: 18,
                        color: service.isAvailable ? AppColors.success : AppColors.error,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        service.isAvailable ? 'Available for booking' : 'Currently unavailable',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: service.isAvailable ? AppColors.success : AppColors.error,
                        ),
                      ),
                    ],
                  ),

                  // ---------------- NEW: Reviews section (Week 6) ----------------
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Reviews', style: AppTextStyles.sectionHeading),
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ReviewsScreen(serviceId: service.id, serviceName: service.name),
                          ),
                        ),
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  RatingSummaryCard(summary: ratingSummary),
                  const SizedBox(height: 16),
                  if (topReviews.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'No reviews yet. Be the first to share your experience.',
                        style: AppTextStyles.bodySmall,
                      ),
                    )
                  else
                    ...topReviews.map(
                          (review) => ReviewCard(
                        review: review,
                        onHelpfulTap: () => ref.read(allReviewsProvider.notifier).markHelpful(review.id),
                      ),
                    ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => WriteReviewScreen(serviceId: service.id, serviceName: service.name),
                        ),
                      ),
                      icon: const Icon(Icons.rate_review_outlined),
                      label: const Text('Write a Review'),
                    ),
                  ),
                  // ---------------- END Reviews section ----------------
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: const Offset(0, -4))],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  style: AppTextStyles.screenTitle.copyWith(fontSize: 20, color: AppColors.primary),
                  children: [
                    TextSpan(text: 'PKR ${_formatPrice(service.price)}'),
                    TextSpan(
                      text: ' /${service.priceUnit}',
                      style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: service.isAvailable
                    ? () => context.push(AppRoutes.bookingPath(service.id))
                    : null,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
                child: const Text('Book Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  }
}