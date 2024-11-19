import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

Widget submittedRequirementsTableLabel(size, ginaTheme) {
  return Container(
    height: size.height * 0.035,
    width: double.infinity,
    color: GinaAppTheme.lightPrimaryColor,
    child: Row(
      children: [
        const Gap(65),
        SizedBox(
          width: size.width * 0.19,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'FULL NAME',
              style: ginaTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Gap(10),
        SizedBox(
          width: size.width * 0.12,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'EMAIL ADDRESS',
              style: ginaTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Gap(10),
        SizedBox(
          width: size.width * 0.12,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'MEDICAL LICENSE NUMBER',
              style: ginaTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Gap(10),
        SizedBox(
          width: size.width * 0.12,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'MEDICAL LICENSE DOCUMENT',
              style: ginaTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Gap(10),
        SizedBox(
          width: size.width * 0.1,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'SUBMISSION DATE',
              style: ginaTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Gap(10),
        SizedBox(
          width: size.width * 0.09,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'VERIFICATION STATUS',
              style: ginaTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
