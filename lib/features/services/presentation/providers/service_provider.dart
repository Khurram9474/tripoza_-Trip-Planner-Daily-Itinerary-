import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripora/features/services/models/travel_service_model.dart';
import 'package:tripora/features/services/mock_travel_services.dart'; // ← adjust path below if different

/// Raw list of all services (mock data source).
final allServicesProvider = Provider<List<TravelService>>((ref) {
  return mockTravelServices;
});

/// Currently selected category filter. 'All' means no filter.
final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

/// Current search query typed by the user.
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Services filtered by category + search query together.
final filteredServicesProvider = Provider<List<TravelService>>((ref) {
  final services = ref.watch(allServicesProvider);
  final category = ref.watch(selectedCategoryProvider);
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();

  return services.where((service) {
    final matchesCategory = category == 'All' || service.category == category;
    final matchesQuery = query.isEmpty ||
        service.name.toLowerCase().contains(query) ||
        service.location.toLowerCase().contains(query) ||
        service.category.toLowerCase().contains(query);
    return matchesCategory && matchesQuery;
  }).toList();
});

/// Look up a single service by id (used by Service Details / Booking screens).
final serviceByIdProvider = Provider.family<TravelService?, String>((ref, id) {
  final services = ref.watch(allServicesProvider);
  try {
    return services.firstWhere((s) => s.id == id);
  } catch (_) {
    return null;
  }
});