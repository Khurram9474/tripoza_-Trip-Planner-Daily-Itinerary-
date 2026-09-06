import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../services/hive_service.dart';
import '../../data/models/trip_model.dart';
import '../../../activities/data/models/activity_model.dart';
import '../../../../core/utils/trip_status_util.dart';

/// Holds the full list of trips, backed by Hive. All mutations write
/// through to the box immediately so data survives app restarts.
class TripNotifier extends StateNotifier<List<TripModel>> {
  TripNotifier() : super(HiveService.tripsBox.values.toList()) {
    _sort();
  }

  static const _uuid = Uuid();

  void _persist() {
    final box = HiveService.tripsBox;
    box.clear();
    for (final trip in state) {
      box.put(trip.id, trip);
    }
  }

  void _sort() {
    final upcoming = state
        .where((t) =>
    TripStatusUtil.getTripStatus(
        startDate: t.startDate, endDate: t.endDate) !=
        TripStatus.completed)
        .toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    final completed = state
        .where((t) =>
    TripStatusUtil.getTripStatus(
        startDate: t.startDate, endDate: t.endDate) ==
        TripStatus.completed)
        .toList()
      ..sort((a, b) => b.endDate.compareTo(a.endDate));

    state = [...upcoming, ...completed];
  }

  TripModel createTrip({
    required String name,
    required String destination,
    required DateTime startDate,
    required DateTime endDate,
    required int travelers,
    String description = '',
  }) {
    final trip = TripModel(
      id: _uuid.v4(),
      name: name,
      destination: destination,
      startDate: startDate,
      endDate: endDate,
      travelers: travelers,
      description: description,
      activities: const [],
      createdAt: DateTime.now(),
    );
    state = [...state, trip];
    _sort();
    _persist();
    return trip;
  }

  void updateTrip(TripModel updated) {
    state = [
      for (final t in state) if (t.id == updated.id) updated else t,
    ];
    _sort();
    _persist();
  }

  void deleteTrip(String tripId) {
    state = state.where((t) => t.id != tripId).toList();
    _persist();
  }

  void addActivity(String tripId, ActivityModel activity) {
    state = [
      for (final t in state)
        if (t.id == tripId)
          t.copyWith(activities: [...t.activities, activity])
        else
          t,
    ];
    _persist();
  }

  void updateActivity(String tripId, ActivityModel updated) {
    state = [
      for (final t in state)
        if (t.id == tripId)
          t.copyWith(
            activities: [
              for (final a in t.activities)
                if (a.id == updated.id) updated else a,
            ],
          )
        else
          t,
    ];
    _persist();
  }

  void deleteActivity(String tripId, String activityId) {
    state = [
      for (final t in state)
        if (t.id == tripId)
          t.copyWith(
            activities:
            t.activities.where((a) => a.id != activityId).toList(),
          )
        else
          t,
    ];
    _persist();
  }

  TripModel? getById(String tripId) {
    for (final t in state) {
      if (t.id == tripId) return t;
    }
    return null;
  }
}

final tripProvider =
StateNotifierProvider<TripNotifier, List<TripModel>>((ref) {
  return TripNotifier();
});

/// Derived: upcoming/ongoing trips (not completed).
final upcomingTripsProvider = Provider<List<TripModel>>((ref) {
  final trips = ref.watch(tripProvider);
  return trips
      .where((t) =>
  TripStatusUtil.getTripStatus(
      startDate: t.startDate, endDate: t.endDate) !=
      TripStatus.completed)
      .toList();
});

/// Derived: completed trips.
final completedTripsProvider = Provider<List<TripModel>>((ref) {
  final trips = ref.watch(tripProvider);
  return trips
      .where((t) =>
  TripStatusUtil.getTripStatus(
      startDate: t.startDate, endDate: t.endDate) ==
      TripStatus.completed)
      .toList();
});

/// Derived: a single trip by id, reactive to updates.
final tripByIdProvider = Provider.family<TripModel?, String>((ref, id) {
  final trips = ref.watch(tripProvider);
  for (final t in trips) {
    if (t.id == id) return t;
  }
  return null;
});

/// Derived: activities for one trip, sorted by day then time.
final activitiesForTripProvider =
Provider.family<List<ActivityModel>, String>((ref, tripId) {
  final trip = ref.watch(tripByIdProvider(tripId));
  if (trip == null) return [];
  final activities = [...trip.activities];
  activities.sort((a, b) {
    final dayCompare = a.day.compareTo(b.day);
    if (dayCompare != 0) return dayCompare;
    return a.time.compareTo(b.time);
  });
  return activities;
});

/// Derived: home-screen dashboard stats.
class DashboardStats {
  final int totalTrips;
  final int plannedDays;
  final int totalActivities;
  final TripModel? nextTrip;

  const DashboardStats({
    required this.totalTrips,
    required this.plannedDays,
    required this.totalActivities,
    required this.nextTrip,
  });
}

final dashboardStatsProvider = Provider<DashboardStats>((ref) {
  final trips = ref.watch(tripProvider);
  final upcoming = ref.watch(upcomingTripsProvider);

  int plannedDays = 0;
  int totalActivities = 0;
  for (final t in trips) {
    plannedDays += t.endDate.difference(t.startDate).inDays + 1;
    totalActivities += t.activities.length;
  }

  return DashboardStats(
    totalTrips: trips.length,
    plannedDays: plannedDays,
    totalActivities: totalActivities,
    nextTrip: upcoming.isNotEmpty ? upcoming.first : null,
  );
});