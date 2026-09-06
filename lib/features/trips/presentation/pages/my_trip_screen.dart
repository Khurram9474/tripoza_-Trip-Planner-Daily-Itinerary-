import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tripora/features/activities/presentation/widgets/custom_app_bar.dart';
import 'package:tripora/features/activities/presentation/widgets/empty_stat.dart';
import '../providers/trip_provider.dart';
import '../widgets/trip_card.dart';
import '../../../../routes/app_router.dart';

class MyTripsScreen extends ConsumerWidget {
  const MyTripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcoming = ref.watch(upcomingTripsProvider);
    final completed = ref.watch(completedTripsProvider);
    final hasAnyTrips = upcoming.isNotEmpty || completed.isNotEmpty;

    return Scaffold(
      appBar: const CustomAppBar(title: 'My Trips'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.createTrip),
        child: const Icon(Icons.add_rounded),
      ),
      body: !hasAnyTrips
          ? Center(
        child: EmptyState(
          icon: Icons.card_travel_rounded,
          title: 'No trips yet',
          message: 'Start planning your next adventure.',
          actionLabel: 'Create Trip',
          onAction: () => context.push(AppRoutes.createTrip),
        ),
      )
          : RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(upcomingTripsProvider);
          ref.invalidate(completedTripsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            if (upcoming.isNotEmpty) ...[
              Text('Upcoming Trips',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              ...upcoming.map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TripCard(
                  trip: t,
                  onTap: () => context
                      .push(AppRoutes.tripDetailsPath(t.id)),
                ),
              )),
              const SizedBox(height: 12),
            ],
            if (completed.isNotEmpty) ...[
              Text('Previous Trips',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              ...completed.map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TripCard(
                  trip: t,
                  onTap: () => context
                      .push(AppRoutes.tripDetailsPath(t.id)),
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }
}