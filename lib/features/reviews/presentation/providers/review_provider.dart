import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../services/hive_service.dart';
import '../../data/models/mock_reviews.dart';
import '../../data/models/review_model.dart';

const _uuid = Uuid();

/// All reviews currently in Hive. Seeds mock data on first run only.
final allReviewsProvider = StateNotifierProvider<ReviewsNotifier, List<ReviewModel>>(
      (ref) => ReviewsNotifier(),
);

class ReviewsNotifier extends StateNotifier<List<ReviewModel>> {
  ReviewsNotifier() : super([]) {
    _seedIfEmpty();
  }

  void _seedIfEmpty() {
    final box = HiveService.reviewsBox;
    if (box.isEmpty) {
      for (final review in mockReviews) {
        box.add(review);
      }
    }
    _refresh();
  }

  void _refresh() {
    state = HiveService.reviewsBox.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> submitReview({
    required String serviceId,
    required String serviceName,
    required String userName,
    required int rating,
    required String reviewText,
    String? imageUrl,
  }) async {
    final review = ReviewModel(
      id: _uuid.v4(),
      serviceId: serviceId,
      serviceName: serviceName,
      userName: userName,
      rating: rating,
      reviewText: reviewText,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
    );
    await HiveService.reviewsBox.add(review);
    _refresh();
  }

  Future<void> markHelpful(String reviewId) async {
    final box = HiveService.reviewsBox;
    final key = box.keys.firstWhere(
          (k) => box.get(k)?.id == reviewId,
      orElse: () => null,
    );
    if (key == null) return;

    final existing = box.get(key)!;
    await box.put(key, existing.copyWith(helpfulCount: existing.helpfulCount + 1));
    _refresh();
  }
}

/// Reviews for a specific service, newest first.
final reviewsForServiceProvider = Provider.family<List<ReviewModel>, String>((ref, serviceId) {
  final reviews = ref.watch(allReviewsProvider);
  return reviews.where((r) => r.serviceId == serviceId).toList();
});

/// Currently selected star filter for a service's review list. 0 = All.
final reviewStarFilterProvider = StateProvider<int>((ref) => 0);

/// Reviews for a service filtered by the selected star rating.
final filteredReviewsProvider = Provider.family<List<ReviewModel>, String>((ref, serviceId) {
  final reviews = ref.watch(reviewsForServiceProvider(serviceId));
  final filter = ref.watch(reviewStarFilterProvider);
  if (filter == 0) return reviews;
  return reviews.where((r) => r.rating == filter).toList();
});

/// Rating summary for a service: average, total, and distribution (5★ down to 1★).
class RatingSummary {
  final double average;
  final int total;
  final Map<int, int> distribution; // star -> count

  const RatingSummary({
    required this.average,
    required this.total,
    required this.distribution,
  });
}

final ratingSummaryProvider = Provider.family<RatingSummary, String>((ref, serviceId) {
  final reviews = ref.watch(reviewsForServiceProvider(serviceId));

  if (reviews.isEmpty) {
    return const RatingSummary(average: 0, total: 0, distribution: {5: 0, 4: 0, 3: 0, 2: 0, 1: 0});
  }

  final distribution = <int, int>{5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
  var sum = 0;
  for (final review in reviews) {
    distribution[review.rating] = (distribution[review.rating] ?? 0) + 1;
    sum += review.rating;
  }

  return RatingSummary(
    average: sum / reviews.length,
    total: reviews.length,
    distribution: distribution,
  );
});