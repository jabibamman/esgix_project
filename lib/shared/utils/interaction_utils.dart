import 'dart:math';

import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';

Widget buildInteractionIcon(IconData icon, int? count) {
  return Row(
    children: [
      Icon(icon, size: 16, color: AppColors.darkGray),
      if (count != null) ...[
        const SizedBox(width: 4),
        Text(formatCount(count), style: TextStyles.bodyText2),
      ],
    ],
  );
}

String formatCount(int count) {
  if (count >= 1000 && count < 1000000) {
    return '${(count / 1000).toStringAsFixed(1)}k';
  } else if (count >= 1000000) {
    return '${(count / 1000000).toStringAsFixed(1)}M';
  }
  return '$count';
}

int generateRandomAudience({int min = 1, int max = 500000}) {
  final random = Random();
  return random.nextInt(max - min + 1) + min;
}
