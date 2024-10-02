import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

Widget periodTrackerLegend(
  ThemeData ginaTheme, {
  bool isEditMode = false,
}) {
  return Row(
    children: [
      Row(
        children: [
          Container(
            width: 14,
            height: 14,
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
            color: GinaAppTheme.lightTertiaryContainer,
            strokeWidth: 1.5,
            dashPattern: const [2, 2],
            borderType: BorderType.Circle,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
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
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              border: isEditMode
                  ? Border.all(
                      color: GinaAppTheme.lightPrimaryColor,
                      width: 1.5,
                    )
                  : null,
              shape: BoxShape.circle,
              color: isEditMode
                  ? null
                  : GinaAppTheme.lightPrimaryColor.withOpacity(0.5),
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
