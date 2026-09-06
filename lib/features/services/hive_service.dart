import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../activities/data/models/activity_model.dart';
import '../trips/data/models/trip_model.dart';

/// Handles all Hive initialization and box access for Tripora.
/// main.dart calls HiveService.init() once, before runApp().
class HiveService {
  HiveService._();

  static Box<TripModel>? _tripsBox;

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(TripModelAdapter());
    Hive.registerAdapter(ActivityModelAdapter());

    _tripsBox = await Hive.openBox<TripModel>(AppConstants.tripsBoxName);
  }

  static Box<TripModel> get tripsBox {
    final box = _tripsBox;
    if (box == null) {
      throw StateError(
        'HiveService.init() must be called before accessing tripsBox.',
      );
    }
    return box;
  }
}