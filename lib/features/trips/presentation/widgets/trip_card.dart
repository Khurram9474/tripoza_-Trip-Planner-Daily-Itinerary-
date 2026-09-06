import 'package:flutter/material.dart';
import 'package:tripora/features/trips/data/models/trip_model.dart';
import 'package:tripora/features/trips/presentation/pages/trip_status_badge.dart' show TripStatusBadge;
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/date_utils.dart';
import '../../../../../core/utils/trip_status_util.dart';

class TripCard extends StatelessWidget {
  final TripModel trip;
  final VoidCallback onTap;

  const TripCard({super.key, required this.trip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final status = TripStatusUtil.getTripStatus(
      startDate: trip.startDate,
      endDate: trip.endDate,
    );
    final days = AppDateUtils.calculateDurationInDays(trip.startDate, trip.endDate);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.secondaryLight.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.landscape_rounded,
                    color: AppColors.secondary, size: 30),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            trip.name,
                            style: AppTextStyles.cardTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        TripStatusBadge(status: status),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(trip.destination, style: AppTextStyles.bodySmall),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded,
                            size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          AppDateUtils.formatDateRange(trip.startDate, trip.endDate),
                          style: AppTextStyles.caption,
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.people_alt_rounded,
                            size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text('${trip.travelers}', style: AppTextStyles.caption),
                        const SizedBox(width: 12),
                        const Icon(Icons.access_time_rounded,
                            size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text('$days ${days == 1 ? 'day' : 'days'}',
                            style: AppTextStyles.caption),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}