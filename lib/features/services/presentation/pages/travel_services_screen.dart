import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../providers/service_provider.dart';
import '../widgets/category_chip.dart';
import '../widgets/service_card.dart';

class TravelServicesScreen extends ConsumerStatefulWidget {
  const TravelServicesScreen({super.key});

  @override
  ConsumerState<TravelServicesScreen> createState() => _TravelServicesScreenState();
}

class _TravelServicesScreenState extends ConsumerState<TravelServicesScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredServices = ref.watch(filteredServicesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final categories = ['All', ...AppConstants.serviceCategories];

    return Scaffold(
      appBar: AppBar(title: const Text('Travel Services')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => ref.read(searchQueryProvider.notifier).state = value,
              decoration: InputDecoration(
                hintText: 'Search by name, location, or category',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryChip(
                  label: category,
                  isSelected: selectedCategory == category,
                  onTap: () => ref.read(selectedCategoryProvider.notifier).state = category,
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filteredServices.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: filteredServices.length,
              itemBuilder: (context, index) {
                final service = filteredServices[index];
                return ServiceCard(
                  service: service,
                  onTap: () => context.push(AppRoutes.serviceDetailsPath(service.id)),
                  onBookNow: () => context.push(AppRoutes.serviceDetailsPath(service.id)),
                );
              },
            ),
          ),
        ],
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
            const Icon(Icons.travel_explore_outlined, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text('No services found', style: AppTextStyles.sectionHeading),
            const SizedBox(height: 8),
            Text(
              'Try another destination or category.',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}