import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/travel_preference.dart';

class TravelPreferenceScreen extends StatefulWidget {
  const TravelPreferenceScreen({super.key});

  @override
  State<TravelPreferenceScreen> createState() => _TravelPreferenceScreenState();
}

class _TravelPreferenceScreenState extends State<TravelPreferenceScreen> {
  TravelStyle _style = TravelStyle.adventure;
  BudgetLevel _budget = BudgetLevel.medium;
  int _duration = 3;
  String _category = AppConstants.serviceCategories.first;
  int _travelers = 1;

  void _submit() {
    final preference = TravelPreference(
      style: _style,
      budget: _budget,
      durationDays: _duration,
      preferredCategory: _category,
      travelers: _travelers,
    );

    context.push(AppRoutes.recommendations, extra: preference);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plan Your Trip')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Tell us your preferences',
            style: AppTextStyles.screenTitle,
          ),
          const SizedBox(height: 4),
          Text(
            'We\'ll suggest travel services that match your style.',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 24),

          Text('Travel Style', style: AppTextStyles.sectionHeading),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: TravelStyle.values.map((style) {
              final isSelected = _style == style;
              return ChoiceChip(
                label: Text(TravelPreference.styleLabels[style]!),
                selected: isSelected,
                onSelected: (_) => setState(() => _style = style),
                selectedColor: AppColors.primary,
                labelStyle: AppTextStyles.bodySmall.copyWith(
                  color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                backgroundColor: AppColors.surfaceVariant,
                side: BorderSide.none,
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          Text('Budget', style: AppTextStyles.sectionHeading),
          const SizedBox(height: 10),
          Row(
            children: BudgetLevel.values.map((budget) {
              final isSelected = _budget == budget;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: OutlinedButton(
                    onPressed: () => setState(() => _budget = budget),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: isSelected ? AppColors.primary : null,
                      foregroundColor: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
                      side: BorderSide(color: isSelected ? AppColors.primary : AppColors.divider),
                    ),
                    child: Text(TravelPreference.budgetLabels[budget]!),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          Text('Trip Duration', style: AppTextStyles.sectionHeading),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.divider),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _duration > 1 ? () => setState(() => _duration--) : null,
                  icon: const Icon(Icons.remove_circle_outline),
                  color: AppColors.primary,
                ),
                Text('$_duration day${_duration == 1 ? '' : 's'}', style: AppTextStyles.sectionHeading),
                IconButton(
                  onPressed: _duration < 30 ? () => setState(() => _duration++) : null,
                  icon: const Icon(Icons.add_circle_outline),
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text('Preferred Category', style: AppTextStyles.sectionHeading),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppConstants.serviceCategories.map((category) {
              final isSelected = _category == category;
              return ChoiceChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (_) => setState(() => _category = category),
                selectedColor: AppColors.primary,
                labelStyle: AppTextStyles.bodySmall.copyWith(
                  color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                backgroundColor: AppColors.surfaceVariant,
                side: BorderSide.none,
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          Text('Number of Travelers', style: AppTextStyles.sectionHeading),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.divider),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _travelers > 1 ? () => setState(() => _travelers--) : null,
                  icon: const Icon(Icons.remove_circle_outline),
                  color: AppColors.primary,
                ),
                Text('$_travelers', style: AppTextStyles.sectionHeading),
                IconButton(
                  onPressed: () => setState(() => _travelers++),
                  icon: const Icon(Icons.add_circle_outline),
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
            child: const Text('Find My Recommendations'),
          ),
        ],
      ),
    );
  }
}