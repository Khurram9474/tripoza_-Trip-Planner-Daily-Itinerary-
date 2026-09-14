import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../services/presentation/providers/booking_provider.dart';
import '../../data/models/booking_model.dart';
import '../widgets/booking_status_badge.dart';

class BookingDetailsScreen extends ConsumerWidget {
  final String bookingId;

  const BookingDetailsScreen({super.key, required this.bookingId});

  Future<void> _confirmCancel(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Confirm Cancellation'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(allBookingsProvider.notifier).cancelBooking(bookingId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking cancelled successfully.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingByIdProvider(bookingId));

    if (booking == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Booking not found.', style: AppTextStyles.bodyMedium)),
      );
    }

    final isCancellable = booking.status == BookingStatus.confirmed || booking.status == BookingStatus.pending;

    return Scaffold(
      appBar: AppBar(title: const Text('Booking Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(booking.bookingId, style: AppTextStyles.screenTitle.copyWith(fontSize: 20)),
              BookingStatusBadge(status: booking.status),
            ],
          ),
          const SizedBox(height: 20),
          _sectionCard('Service', [
            _row('Service', booking.serviceName),
            _row('Category', booking.serviceCategory),
          ]),
          const SizedBox(height: 16),
          _sectionCard('Customer Information', [
            _row('Full Name', booking.customerName),
            _row('Phone', booking.phone),
            _row('Email', booking.email),
          ]),
          const SizedBox(height: 16),
          _sectionCard('Booking Information', [
            _row('Booking Date', DateFormat('d MMMM yyyy').format(booking.bookingDate)),
            _row('Number of People', '${booking.numberOfPeople}'),
            _row('Price per Person', 'PKR ${_formatPrice(booking.pricePerPerson)}'),
            _row('Total Amount', 'PKR ${_formatPrice(booking.totalAmount)}'),
            if (booking.specialRequest.isNotEmpty) _row('Special Request', booking.specialRequest),
          ]),
          const SizedBox(height: 16),
          _sectionCard('Booked On', [
            _row('Created', DateFormat('d MMMM yyyy, h:mm a').format(booking.createdAt)),
          ]),
          if (isCancellable) ...[
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _confirmCancel(context, ref),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  minimumSize: const Size(0, 52),
                ),
                icon: const Icon(Icons.cancel_outlined),
                label: const Text('Cancel Booking'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _sectionCard(String title, List<Widget> rows) {
    return Card(
      elevation: 0,
      color: AppColors.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.sectionHeading),
            const SizedBox(height: 12),
            ...rows,
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 130, child: Text(label, style: AppTextStyles.bodySmall)),
          Expanded(child: Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  }
}