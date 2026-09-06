import 'package:flutter/material.dart';
import '../../data/models/activity_model.dart';
import '../../../../core/theme/app_colors.dart';
import 'activity_card.dart';

/// Vertical timeline connecting activities for a single day with a
/// dotted rail + dot per activity, ordered chronologically.
class ActivityTimeline extends StatelessWidget {
  final List<ActivityModel> activities;
  final void Function(ActivityModel) onActivityTap;
  final void Function(ActivityModel) onActivityDelete;

  const ActivityTimeline({
    super.key,
    required this.activities,
    required this.onActivityTap,
    required this.onActivityDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        final isLast = index == activities.length - 1;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(top: 18),
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(width: 2, color: AppColors.divider),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ActivityCard(
                    activity: activity,
                    onTap: () => onActivityTap(activity),
                    onDelete: () => onActivityDelete(activity),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}