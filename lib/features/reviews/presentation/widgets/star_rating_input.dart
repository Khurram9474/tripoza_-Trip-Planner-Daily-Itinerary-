import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Interactive tappable star selector for the Write Review form.
class StarRatingInput extends StatelessWidget {
  final int rating; // 0 = none selected
  final ValueChanged<int> onChanged;

  const StarRatingInput({super.key, required this.rating, required this.onChanged});

  static const _labels = {1: 'Poor', 2: 'Needs Improvement', 3: 'Average', 4: 'Good', 5: 'Excellent'};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starValue = index + 1;
            return IconButton(
              onPressed: () => onChanged(starValue),
              icon: Icon(
                rating >= starValue ? Icons.star : Icons.star_border,
                color: AppColors.warning,
                size: 36,
              ),
            );
          }),
        ),
        if (rating > 0)
          Text(_labels[rating]!, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}