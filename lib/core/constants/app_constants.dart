/// App-wide constant values that aren't colors or text styles.
class AppConstants {
  AppConstants._();
  static const String bookingsBoxName = 'bookingsBox';  // ← 1. FIXED casing here (was 'bookings_box')
  static const String appName = 'Tripora';
  static const String appTagline = 'Plan. Explore. Book. Remember.';  // ← 2. FIXED text here (was missing "Book.")
  static const String reviewsBoxName = 'reviewsBox';
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

  // Travel service categories (Week 5)          // ← 3. ADD this whole block
  static const List<String> serviceCategories = [ //    as a new block, anywhere
    'Hotels',                                     //    after activityCategories
    'Tours',                                      //    (order doesn't matter,
    'Transportation',                             //    just keep it inside the
    'Activities',                                 //    class body before the
  ];                                              //    closing brace)
}