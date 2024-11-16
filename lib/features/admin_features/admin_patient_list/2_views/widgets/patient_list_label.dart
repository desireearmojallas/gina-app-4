import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class PatientListLabel extends StatelessWidget {
  const PatientListLabel({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;

    return Container(
      height: size.height * 0.035,
      width: size.width * 0.9,
      color: GinaAppTheme.lightPrimaryColor,
      child: Row(
        children: [
          const Gap(65),
          SizedBox(
            width: size.width * 0.158,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'NAME',
                style: ginaTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: size.width * 0.138,
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
          SizedBox(
            width: size.width * 0.08,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'GENDER',
                style: ginaTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: size.width * 0.198,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'ADDRESS',
                style: ginaTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: size.width * 0.07,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'DATE OF BIRTH',
                style: ginaTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: size.width * 0.07,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'DATE REGISTERED',
                style: ginaTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: size.width * 0.08,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'TOTAL APPTS. BOOKED',
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
