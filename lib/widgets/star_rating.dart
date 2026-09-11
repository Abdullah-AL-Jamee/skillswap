import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Row of stars used on the mentor cards, matching the prototype.
class StarRating extends StatelessWidget {
  const StarRating({super.key, required this.rating, this.reviewCount});

  final double rating;
  final int? reviewCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 5; i++)
          Icon(
            i <= rating.round() ? Icons.star : Icons.star_border,
            size: 18,
            color: AppColors.star,
          ),
        if (reviewCount != null) ...[
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              '($reviewCount reviews)',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, color: AppColors.muted),
            ),
          ),
        ],
      ],
    );
  }
}
