/// Possible lifecycle states for a trip, derived dynamically — never
/// hardcoded on the model itself.
enum TripStatus { upcoming, ongoing, completed }

class TripStatusUtil {
  TripStatusUtil._();

  /// Determines a trip's current status by comparing today's date
  /// against the trip's start/end dates.
  static TripStatus getTripStatus({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);

    if (today.isBefore(start)) return TripStatus.upcoming;
    if (today.isAfter(end)) return TripStatus.completed;
    return TripStatus.ongoing;
  }

  static String label(TripStatus status) {
    switch (status) {
      case TripStatus.upcoming:
        return 'Upcoming';
      case TripStatus.ongoing:
        return 'Ongoing';
      case TripStatus.completed:
        return 'Completed';
    }
  }
}