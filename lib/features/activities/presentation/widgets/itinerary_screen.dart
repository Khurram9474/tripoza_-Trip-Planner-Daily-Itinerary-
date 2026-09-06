import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tripora/features/activities/presentation/widgets/custom_app_bar.dart';
import 'package:tripora/features/activities/presentation/widgets/empty_stat.dart';
import '../../data/models/activity_model.dart';
import '../../../trips/presentation/providers/trip_provider.dart';
import '../widgets/day_selector.dart';
import '../widgets/activity_timeline.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../routes/app_router.dart';

class ItineraryScreen extends ConsumerStatefulWidget {
  final String tripId;

  const ItineraryScreen({super.key, required this.tripId});

  @override
  ConsumerState<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends ConsumerState<ItineraryScreen> {
  int _selectedDay = 1;

  Future<void> _confirmAndDelete(ActivityModel activity) async {
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Delete Activity',
      message: 'Are you sure you want to delete this activity?',
      confirmLabel: 'Delete',
    );
    if (confirmed) {
      ref.read(tripProvider.notifier).deleteActivity(widget.tripId, activity.id);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Activity deleted')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final trip = ref.watch(tripByIdProvider(widget.tripId));
    final allActivities = ref.watch(activitiesForTripProvider(widget.tripId));

    if (trip == null) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'Itinerary', showBack: true),
        body: const Center(child: Text('This trip no longer exists.')),
      );
    }

    final totalDays = AppDateUtils.calculateDurationInDays(trip.startDate, trip.endDate);
    final dayActivities = allActivities.where((a) => a.day == _selectedDay).toList();

    return Scaffold(
      appBar: CustomAppBar(title: '${trip.name} — Itinerary', showBack: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(
          '${AppRoutes.addActivityPath(trip.id)}?day=$_selectedDay',
        ),
        child: const Icon(Icons.add_rounded),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          DaySelector(
            totalDays: totalDays,
            selectedDay: _selectedDay,
            onSelected: (d) => setState(() => _selectedDay = d),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: dayActivities.isEmpty
                ? Center(
              child: EmptyState(
                icon: Icons.event_note_rounded,
                title: 'No activities planned',
                message: 'Add your first activity.',
                actionLabel: 'Add Activity',
                onAction: () => context.push(
                  '${AppRoutes.addActivityPath(trip.id)}?day=$_selectedDay',
                ),
              ),
            )
                : ActivityTimeline(
              activities: dayActivities,
              onActivityTap: (a) => context.push(
                AppRoutes.editActivityPath(trip.id, a.id),
              ),
              onActivityDelete: _confirmAndDelete,
            ),
          ),
        ],
      ),
    );
  }
}