import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

Widget periodTrackerLegend(ThemeData ginaTheme) {
  return Row(
    children: [
      Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: GinaAppTheme.lightTertiaryContainer,
            ),
          ),
          const Gap(8),
          Text(
            'Period',
            style: ginaTheme.textTheme.bodySmall,
          ),
        ],
      ),
      const Gap(20),
      Row(
        children: [
          DottedBorder(
            color: GinaAppTheme.lightOnPrimaryColor,
            strokeWidth: 1.5,
            dashPattern: const [2, 2],
            borderType: BorderType.Circle,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: GinaAppTheme.lightSurfaceTint,
              ),
            ),
          ),
          const Gap(8),
          Text(
            'Average-based Prediction',
            style: ginaTheme.textTheme.bodySmall,
          ),
        ],
      ),
      const Gap(20),
      Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: GinaAppTheme.lightPrimaryColor,
            ),
          ),
          const Gap(8),
          Text(
            '28-day Prediction',
            style: ginaTheme.textTheme.bodySmall,
          ),
        ],
      ),
    ],
  );
}
