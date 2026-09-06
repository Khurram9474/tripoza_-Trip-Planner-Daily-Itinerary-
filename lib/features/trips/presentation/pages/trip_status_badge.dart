import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/trip_status_util.dart';

class TripStatusBadge extends StatelessWidget {
  final TripStatus status;

  const TripStatusBadge({super.key, required this.status});

  Color get _bg {
    switch (status) {
      case TripStatus.upcoming:
        return AppColors.upcomingBg;
      case TripStatus.ongoing:
        return AppColors.ongoingBg;
      case TripStatus.completed:
        return AppColors.completedBg;
    }
  }

  Color get _text {
    switch (status) {
      case TripStatus.upcoming:
        return AppColors.upcomingText;
      case TripStatus.ongoing:
        return AppColors.ongoingText;
      case TripStatus.completed:
        return AppColors.completedText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: _bg, borderRadius: BorderRadius.circular(8)),
      child: Text(
        TripStatusUtil.label(status),
        style: AppTextStyles.caption.copyWith(color: _text, fontWeight: FontWeight.w600),
      ),
    );
  }
}