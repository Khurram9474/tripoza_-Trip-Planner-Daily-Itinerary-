import 'package:intl/intl.dart';

/// Date formatting and duration calculations used across trip/activity
/// screens. Named AppDateUtils to avoid clashing with Dart's own DateUtils.
class AppDateUtils {
  AppDateUtils._();

  static final DateFormat _shortDate = DateFormat('d MMM yyyy');
  static final DateFormat _monthDay = DateFormat('d MMM');

  static String formatDate(DateTime date) => _shortDate.format(date);

  static String formatDateRange(DateTime start, DateTime end) {
    if (start.year == end.year) {
      return '${_monthDay.format(start)} - ${_shortDate.format(end)}';
    }
    return '${_shortDate.format(start)} - ${_shortDate.format(end)}';
  }

  /// Total trip duration in days, inclusive of both start and end date.
  /// e.g. 10 Sep -> 15 Sep = 6 days.
  static int calculateDurationInDays(DateTime start, DateTime end) {
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day);
    return e.difference(s).inDays + 1;
  }

  static bool isEndDateValid(DateTime start, DateTime end) {
    return !end.isBefore(start);
  }
}