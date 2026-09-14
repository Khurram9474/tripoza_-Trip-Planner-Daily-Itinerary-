import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../services/presentation/providers/booking_provider.dart';
import '../../data/models/booking_model.dart';
import 'my_bookings_screen.dart';

class BookingConfirmationScreen extends ConsumerWidget {
  final String bookingId;

  const BookingConfirmationScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingByIdProvider(bookingId));

    if (booking == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Booking not found.', style: AppTextStyles.bodyMedium)),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.12), shape: BoxShape.circle),
                child: const Icon(Icons.check_circle, color: AppColors.success, size: 64),
              ),
              const SizedBox(height: 24),
              Text('Booking Confirmed!', style: AppTextStyles.screenTitle, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                'Your travel booking has been successfully placed.',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              Card(
                elevation: 0,
                color: AppColors.surfaceVariant,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _row('Booking ID', booking.bookingId, emphasize: true),
                      const Divider(height: 24),
                      _row('Service', booking.serviceName),
                      const SizedBox(height: 10),
                      _row('Date', DateFormat('d MMMM yyyy').format(booking.bookingDate)),
                      const SizedBox(height: 10),
                      _row('Travelers', '${booking.numberOfPeople}'),
                      const SizedBox(height: 10),
                      _row('Total Amount', 'PKR ${_formatPrice(booking.totalAmount)}'),
                      const SizedBox(height: 10),
                      _statusRow(booking.status),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const MyBookingsScreen()),
                        (route) => route.isFirst,
                  ),
                  style: ElevatedButton.styleFrom(minimumSize: const Size(0, 52)),
                  child: const Text('View My Bookings'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  style: OutlinedButton.styleFrom(minimumSize: const Size(0, 52)),
                  child: const Text('Back to Home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool emphasize = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodySmall),
        Text(
          value,
          style: emphasize
              ? AppTextStyles.sectionHeading.copyWith(color: AppColors.primary)
              : AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _statusRow(BookingStatus status) {
    final (bg, fg, label) = switch (status) {
      BookingStatus.confirmed => (AppColors.ongoingBg, AppColors.ongoingText, 'Confirmed'),
      BookingStatus.pending => (AppColors.upcomingBg, AppColors.upcomingText, 'Pending'),
      BookingStatus.cancelled => (AppColors.completedBg, AppColors.error, 'Cancelled'),
      BookingStatus.completed => (AppColors.completedBg, AppColors.completedText, 'Completed'),
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Status', style: AppTextStyles.bodySmall),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
          child: Text(label, style: AppTextStyles.caption.copyWith(color: fg, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  }
}