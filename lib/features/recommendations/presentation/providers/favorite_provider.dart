import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_constants.dart';

/// Stores favorited service IDs as a simple string set in Hive.
final favoriteServiceIdsProvider = StateNotifierProvider<FavoriteServiceIdsNotifier, Set<String>>(
      (ref) => FavoriteServiceIdsNotifier(),
);

class FavoriteServiceIdsNotifier extends StateNotifier<Set<String>> {
  FavoriteServiceIdsNotifier() : super({}) {
    _load();
  }

  Box get _box => Hive.box(AppConstants.favoritesBoxName);

  void _load() {
    final stored = _box.get('serviceIds', defaultValue: <String>[]) as List;
    state = stored.cast<String>().toSet();
  }

  Future<void> toggle(String serviceId) async {
    final updated = Set<String>.from(state);
    if (updated.contains(serviceId)) {
      updated.remove(serviceId);
    } else {
      updated.add(serviceId);
    }
    state = updated;
    await _box.put('serviceIds', updated.toList());
  }
}