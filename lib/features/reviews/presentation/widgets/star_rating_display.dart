import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Read-only star display, e.g. for showing a review's existing rating.
class StarRatingDisplay extends StatelessWidget {
  final double rating; // supports fractional for averages, e.g. 4.7
  final double size;

  const StarRatingDisplay({super.key, required this.rating, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        IconData icon;
        if (rating >= starValue) {
          icon = Icons.star;
        } else if (rating >= starValue - 0.5) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }
        return Icon(icon, size: size, color: AppColors.warning);
      }),
    );
  }
}