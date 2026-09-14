import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../services/presentation/providers/booking_provider.dart';

class BookingSummaryScreen extends ConsumerStatefulWidget {
  final String serviceId;
  final String serviceName;
  final String serviceCategory;
  final String customerName;
  final String phone;
  final String email;
  final DateTime bookingDate;
  final int numberOfPeople;
  final double pricePerPerson;
  final String specialRequest;

  const BookingSummaryScreen({
    super.key,
    required this.serviceId,
    required this.serviceName,
    required this.serviceCategory,
    required this.customerName,
    required this.phone,
    required this.email,
    required this.bookingDate,
    required this.numberOfPeople,
    required this.pricePerPerson,
    required this.specialRequest,
  });

  @override
  ConsumerState<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends ConsumerState<BookingSummaryScreen> {
  bool _isSaving = false;

  double get _totalAmount => widget.pricePerPerson * widget.numberOfPeople;

  Future<void> _confirmBooking() async {
    setState(() => _isSaving = true);

    final booking = await ref.read(allBookingsProvider.notifier).createBooking(
      customerName: widget.customerName,
      phone: widget.phone,
      email: widget.email,
      serviceId: widget.serviceId,
      serviceName: widget.serviceName,
      serviceCategory: widget.serviceCategory,
      bookingDate: widget.bookingDate,
      numberOfPeople: widget.numberOfPeople,
      pricePerPerson: widget.pricePerPerson,
      totalAmount: _totalAmount,
      specialRequest: widget.specialRequest,
    );

    if (!mounted) return;

    setState(() => _isSaving = false);

    context.pushReplacement(AppRoutes.bookingConfirmationPath(booking.bookingId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Summary')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionCard(
            title: 'Service',
            rows: [
              _row('Service', widget.serviceName),
              _row('Category', widget.serviceCategory),
            ],
          ),
          const SizedBox(height: 16),
          _sectionCard(
            title: 'Traveler Information',
            rows: [
              _row('Full Name', widget.customerName),
              _row('Phone', widget.phone),
              _row('Email', widget.email),
              if (widget.specialRequest.isNotEmpty) _row('Special Request', widget.specialRequest),
            ],
          ),
          const SizedBox(height: 16),
          _sectionCard(
            title: 'Booking Details',
            rows: [
              _row('Date', DateFormat('d MMMM yyyy').format(widget.bookingDate)),
              _row('Number of Travelers', '${widget.numberOfPeople}'),
              _row('Price per Person', 'PKR ${_formatPrice(widget.pricePerPerson)}'),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Amount', style: AppTextStyles.sectionHeading),
                Text(
                  'PKR ${_formatPrice(_totalAmount)}',
                  style: AppTextStyles.screenTitle.copyWith(fontSize: 20, color: AppColors.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isSaving ? null : () => context.pop(),
                  style: OutlinedButton.styleFrom(minimumSize: const Size(0, 52)),
                  child: const Text('Edit Booking'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _confirmBooking,
                  style: ElevatedButton.styleFrom(minimumSize: const Size(0, 52)),
                  child: _isSaving
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                      : const Text('Confirm Booking'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required List<Widget> rows}) {
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
          SizedBox(
            width: 130,
            child: Text(label, style: AppTextStyles.bodySmall),
          ),
          Expanded(
            child: Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  }
}