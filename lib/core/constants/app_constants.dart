/// App-wide constant values that aren't colors or text styles.
class AppConstants {
  AppConstants._();

  static const String appName = 'Tripora';
  static const String appTagline = 'Plan. Explore. Remember.';

  // Hive box names (used in Phase 5)
  static const String tripsBoxName = 'tripsBox';

  // Activity time-of-day slots
  static const List<String> dayPeriods = ['Morning', 'Afternoon', 'Evening'];

  // Activity categories
  static const List<String> activityCategories = [
    'Sightseeing',
    'Food',
    'Adventure',
    'Shopping',
    'Culture',
    'Entertainment',
  ];
}