import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

Widget patientConsultationHistoryTableLabel(size, ginaTheme) {
  return Container(
    height: size.height * 0.035,
    width: double.infinity,
    color: GinaAppTheme.lightPrimaryColor,
    child: Row(
      children: [
        const Gap(65),
        SizedBox(
          width: size.width * 0.09,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'APPOINTMENT ID',
              style: ginaTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // const Gap(10),
        SizedBox(
          width: size.width * 0.16,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'DOCTOR CONSULTED',
              style: ginaTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Gap(20),
        SizedBox(
          width: size.width * 0.09,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'DATE OF CONSULTATION',
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
              'TIME OF CONSULTATION',
              style: ginaTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Gap(10),
        SizedBox(
          width: size.width * 0.15,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'CLINIC ADDRESS',
              style: ginaTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Gap(20),
        SizedBox(
          width: size.width * 0.095,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'MODE OF APPOINTMENT',
              style: ginaTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Gap(30),
        SizedBox(
          width: size.width * 0.06,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'STATUS',
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
