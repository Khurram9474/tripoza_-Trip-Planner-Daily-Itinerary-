import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tripora/features/activities/presentation/widgets/app_button.dart';
import 'package:tripora/features/activities/presentation/widgets/empty_stat.dart';
import '../providers/trip_provider.dart';
import '../widgets/trip_card.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../routes/app_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(dashboardStatsProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Plan your next adventure', style: AppTextStyles.screenTitle),
            const SizedBox(height: 20),

            // Stat row
            Row(
              children: [
                _StatChip(label: 'Trips', value: '${stats.totalTrips}'),
                const SizedBox(width: 10),
                _StatChip(label: 'Days', value: '${stats.plannedDays}'),
                const SizedBox(width: 10),
                _StatChip(label: 'Activities', value: '${stats.totalActivities}'),
              ],
            ),
            const SizedBox(height: 24),

            Text('Upcoming Adventure', style: AppTextStyles.sectionHeading),
            const SizedBox(height: 10),
            stats.nextTrip == null
                ? EmptyState(
              icon: Icons.explore_rounded,
              title: 'No trips yet',
              message: 'Start planning your next adventure.',
              actionLabel: 'Create Trip',
              onAction: () => context.push(AppRoutes.createTrip),
            )
                : TripCard(
              trip: stats.nextTrip!,
              onTap: () => context
                  .push(AppRoutes.tripDetailsPath(stats.nextTrip!.id)),
            ),
            const SizedBox(height: 24),

            Text('Quick Actions', style: AppTextStyles.sectionHeading),
            const SizedBox(height: 10),
            AppButton(
              label: 'Create Trip',
              icon: Icons.add_rounded,
              onPressed: () => context.push(AppRoutes.createTrip),
            ),
            const SizedBox(height: 10),
            AppButton(
              label: 'View My Trips',
              outlined: true,
              onPressed: () => context.push(AppRoutes.myTrips),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8)],
        ),
        child: Column(
          children: [
            Text(value, style: AppTextStyles.screenTitle),
            const SizedBox(height: 2),
            Text(label, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}