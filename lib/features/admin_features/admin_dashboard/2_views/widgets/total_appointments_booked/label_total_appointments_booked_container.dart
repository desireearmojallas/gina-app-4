import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class TotalAppointmentsBookedTable extends StatelessWidget {
  const TotalAppointmentsBookedTable({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;

    return Container(
      height: size.height * 0.035,
      width: double.infinity,
      color: GinaAppTheme.lightPrimaryColor,
      child: Row(
        children: [
          const Gap(40),
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
          const Gap(10),
          SizedBox(
            width: size.width * 0.1,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'PATIENT NAME',
                style: ginaTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Gap(25),
          SizedBox(
            width: size.width * 0.14,
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
          const Gap(25),
          SizedBox(
            width: size.width * 0.12,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'DATE & TIME OF CONSULTATION',
                style: ginaTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: size.width * 0.16,
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
          const Gap(15),
          SizedBox(
            width: size.width * 0.08,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'MODE OF APPT.',
                style: ginaTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: size.width * 0.06,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'APPT. STATUS',
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
}
