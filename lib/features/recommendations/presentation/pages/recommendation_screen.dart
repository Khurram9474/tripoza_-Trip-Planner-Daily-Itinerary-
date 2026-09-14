import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../services/presentation/providers/service_provider.dart';
import '../../data/models/recommendation_result.dart';
import '../../data/models/travel_preference.dart';
import '../../data/recommendation_engine.dart';
import '../providers/favorite_provider.dart';
import '../widgets/recommendation_card.dart';

class RecommendationScreen extends ConsumerWidget {
  final TravelPreference preference;

  const RecommendationScreen({super.key, required this.preference});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allServices = ref.watch(allServicesProvider);
    final results = RecommendationEngine.generate(preference: preference, allServices: allServices);
    final favoriteIds = ref.watch(favoriteServiceIdsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Recommended For You')),
      body: results.isEmpty ? _buildEmptyState(context) : _buildResultsList(context, ref, results, favoriteIds),
    );
  }

  Widget _buildResultsList(
      BuildContext context,
      WidgetRef ref,
      List<RecommendationResult> results,
      Set<String> favoriteIds,
      ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Found ${results.length} recommendation${results.length == 1 ? '' : 's'} based on your preferences',
          style: AppTextStyles.bodySmall,
        ),
        const SizedBox(height: 16),
        ...results.map(
              (result) => RecommendationCard(
            result: result,
            isSaved: favoriteIds.contains(result.service.id),
            onViewDetails: () => context.push(AppRoutes.serviceDetailsPath(result.service.id)),
            onSaveToggle: () => ref.read(favoriteServiceIdsProvider.notifier).toggle(result.service.id),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_outlined, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text('No matches found', style: AppTextStyles.sectionHeading),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your preferences for better results.',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Adjust Preferences'),
            ),
          ],
        ),
      ),
    );
  }
}