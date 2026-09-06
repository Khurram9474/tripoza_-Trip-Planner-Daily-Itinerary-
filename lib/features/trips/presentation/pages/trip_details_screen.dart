import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tripora/features/activities/presentation/widgets/app_button.dart';
import 'package:tripora/features/trips/presentation/pages/trip_header.dart';
import 'package:tripora/features/trips/presentation/pages/trip_stats.dart' show TripStats;
import '../providers/trip_provider.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../routes/app_router.dart';

class TripDetailsScreen extends ConsumerWidget {
  final String tripId;

  const TripDetailsScreen({super.key, required this.tripId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trip = ref.watch(tripByIdProvider(tripId));
    final activities = ref.watch(activitiesForTripProvider(tripId));

    if (trip == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Trip Details')),
        body: const Center(child: Text('This trip no longer exists.')),
      );
    }

    final totalDays = AppDateUtils.calculateDurationInDays(trip.startDate, trip.endDate);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  TripHeader(trip: trip),
                  Positioned(
                    top: 8,
                    left: 4,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 4,
                    child: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
                      onSelected: (value) async {
                        if (value == 'edit') {
                          context.push(AppRoutes.editTripPath(trip.id));
                        } else if (value == 'delete') {
                          final confirmed = await showConfirmationDialog(
                            context,
                            title: 'Delete Trip',
                            message:
                            'Are you sure you want to delete "${trip.name}"? This cannot be undone.',
                            confirmLabel: 'Delete',
                          );
                          if (confirmed) {
                            ref.read(tripProvider.notifier).deleteTrip(trip.id);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Trip deleted')),
                              );
                              context.go(AppRoutes.myTrips);
                            }
                          }
                        }
                      },
                      itemBuilder: (ctx) => const [
                        PopupMenuItem(value: 'edit', child: Text('Edit Trip')),
                        PopupMenuItem(value: 'delete', child: Text('Delete Trip')),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TripStats(
                      totalDays: totalDays,
                      totalActivities: activities.length,
                      travelers: trip.travelers,
                    ),
                    const SizedBox(height: 24),
                    Text('Trip Information', style: AppTextStyles.sectionHeading),
                    const SizedBox(height: 8),
                    Text(
                      trip.description.isEmpty
                          ? 'No additional notes for this trip yet.'
                          : trip.description,
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 28),
                    AppButton(
                      label: 'View Itinerary',
                      icon: Icons.map_rounded,
                      onPressed: () =>
                          context.push(AppRoutes.itineraryPath(trip.id)),
                    ),
                    const SizedBox(height: 10),
                    AppButton(
                      label: 'Add Activity',
                      icon: Icons.add_rounded,
                      outlined: true,
                      onPressed: () =>
                          context.push(AppRoutes.addActivityPath(trip.id)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}