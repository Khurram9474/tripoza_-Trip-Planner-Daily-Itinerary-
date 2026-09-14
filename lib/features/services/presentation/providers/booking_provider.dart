import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripora/features/bookings/data/models/booking_model.dart';
import 'package:uuid/uuid.dart';
import '../../../services/hive_service.dart';

const _uuid = Uuid();

/// All bookings currently stored in Hive, newest first.
final allBookingsProvider = StateNotifierProvider<BookingsNotifier, List<BookingModel>>(
      (ref) => BookingsNotifier(),
);

class BookingsNotifier extends StateNotifier<List<BookingModel>> {
  BookingsNotifier() : super(HiveService.bookingsBox.values.toList().reversed.toList());

  void _refresh() {
    state = HiveService.bookingsBox.values.toList().reversed.toList();
  }

  /// Creates a booking, generates a booking ID, persists it, and returns it.
  Future<BookingModel> createBooking({
    required String customerName,
    required String phone,
    required String email,
    required String serviceId,
    required String serviceName,
    required String serviceCategory,
    required DateTime bookingDate,
    required int numberOfPeople,
    required double pricePerPerson,
    required double totalAmount,
    String specialRequest = '',
  }) async {
    final now = DateTime.now();
    final shortId = _uuid.v4().substring(0, 6).toUpperCase();
    final bookingId = 'TRP-${now.year}-$shortId';

    final booking = BookingModel(
      id: _uuid.v4(),
      bookingId: bookingId,
      customerName: customerName,
      phone: phone,
      email: email,
      serviceId: serviceId,
      serviceName: serviceName,
      serviceCategory: serviceCategory,
      bookingDate: bookingDate,
      numberOfPeople: numberOfPeople,
      pricePerPerson: pricePerPerson,
      totalAmount: totalAmount,
      specialRequest: specialRequest,
      status: BookingStatus.confirmed,
      createdAt: now,
    );

    await HiveService.bookingsBox.add(booking);
    _refresh();
    return booking;
  }

  Future<void> cancelBooking(String bookingId) async {
    final box = HiveService.bookingsBox;
    final key = box.keys.firstWhere(
          (k) => box.get(k)?.bookingId == bookingId,
      orElse: () => null,
    );
    if (key == null) return;

    final existing = box.get(key)!;
    await box.put(key, existing.copyWith(status: BookingStatus.cancelled));
    _refresh();
  }
}

/// Bookings split into upcoming (date is today or later, not cancelled) vs previous.
final upcomingBookingsProvider = Provider<List<BookingModel>>((ref) {
  final bookings = ref.watch(allBookingsProvider);
  final now = DateTime.now();
  return bookings.where((b) {
    return b.status != BookingStatus.cancelled && b.bookingDate.isAfter(now);
  }).toList();
});

final previousBookingsProvider = Provider<List<BookingModel>>((ref) {
  final bookings = ref.watch(allBookingsProvider);
  final now = DateTime.now();
  return bookings.where((b) {
    return b.status == BookingStatus.cancelled || b.bookingDate.isBefore(now);
  }).toList();
});

/// Look up a single booking by its human-readable bookingId (e.g. TRP-2026-8F42A1).
final bookingByIdProvider = Provider.family<BookingModel?, String>((ref, bookingId) {
  final bookings = ref.watch(allBookingsProvider);
  try {
    return bookings.firstWhere((b) => b.bookingId == bookingId);
  } catch (_) {
    return null;
  }
});