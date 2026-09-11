import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Circular initial badge used in place of a profile photo.
class AvatarBubble extends StatelessWidget {
  const AvatarBubble({super.key, required this.initial, this.size = 96});

  final String initial;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.avatarFill,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.avatarBorder, width: 1.5),
      ),
      child: Text(
        initial,
        style: TextStyle(
          fontSize: size * 0.38,
          fontWeight: FontWeight.w700,
          color: AppColors.heading,
        ),
      ),
    );
  }
}
