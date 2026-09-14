import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../activities/data/models/activity_model.dart';
import '../trips/data/models/trip_model.dart';
import '../bookings/data/models/booking_model.dart';
import '../reviews/data/models/review_model.dart';

class HiveService {
  HiveService._();

  static Box<TripModel>? _tripsBox;
  static Box<BookingModel>? _bookingsBox;
  static Box<ReviewModel>? _reviewsBox;

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(TripModelAdapter());
    Hive.registerAdapter(ActivityModelAdapter());
    Hive.registerAdapter(BookingStatusAdapter());
    Hive.registerAdapter(BookingModelAdapter());
    Hive.registerAdapter(ReviewModelAdapter());

    _tripsBox = await Hive.openBox<TripModel>(AppConstants.tripsBoxName);
    _bookingsBox = await Hive.openBox<BookingModel>(AppConstants.bookingsBoxName);
    _reviewsBox = await Hive.openBox<ReviewModel>(AppConstants.reviewsBoxName);
  }

  static Box<TripModel> get tripsBox {
    final box = _tripsBox;
    if (box == null) {
      throw StateError('HiveService.init() must be called before accessing tripsBox.');
    }
    return box;
  }

  static Box<BookingModel> get bookingsBox {
    final box = _bookingsBox;
    if (box == null) {
      throw StateError('HiveService.init() must be called before accessing bookingsBox.');
    }
    return box;
  }

  static Box<ReviewModel> get reviewsBox {
    final box = _reviewsBox;
    if (box == null) {
      throw StateError('HiveService.init() must be called before accessing reviewsBox.');
    }
    return box;
  }
}