import 'package:flutter/material.dart';
import '../../data/models/trip_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/trip_status_util.dart';
import 'trip_status_badge.dart';

class TripHeader extends StatelessWidget {
  final TripModel trip;

  const TripHeader({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final status = TripStatusUtil.getTripStatus(
      startDate: trip.startDate,
      endDate: trip.endDate,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.landscape_rounded,
                  color: AppColors.textOnPrimary, size: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  trip.destination,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textOnPrimary.withValues(alpha: 0.85)),
                ),
              ),
              TripStatusBadge(status: status),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            trip.name,
            style: AppTextStyles.displayLarge.copyWith(color: AppColors.textOnPrimary, fontSize: 26),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.calendar_today_rounded, size: 15, color: Colors.white70),
              const SizedBox(width: 6),
              Text(
                AppDateUtils.formatDateRange(trip.startDate, trip.endDate),
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }
}