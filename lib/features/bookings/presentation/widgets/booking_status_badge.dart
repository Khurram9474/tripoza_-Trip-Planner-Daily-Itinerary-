import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/booking_model.dart';

class BookingStatusBadge extends StatelessWidget {
  final BookingStatus status;

  const BookingStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = switch (status) {
      BookingStatus.confirmed => (AppColors.ongoingBg, AppColors.ongoingText, 'Confirmed'),
      BookingStatus.pending => (AppColors.upcomingBg, AppColors.upcomingText, 'Pending'),
      BookingStatus.cancelled => (AppColors.completedBg, AppColors.error, 'Cancelled'),
      BookingStatus.completed => (AppColors.completedBg, AppColors.completedText, 'Completed'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: AppTextStyles.caption.copyWith(color: fg, fontWeight: FontWeight.bold)),
    );
  }
}