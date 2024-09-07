import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class UpcomingAppointmentsContainer extends StatelessWidget {
  const UpcomingAppointmentsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final ginaTheme = Theme.of(context);
    return Container(
      width: width / 1.05,
      height: height * 0.09,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                'Oct',
                style: ginaTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              Text(
                '20',
                style: ginaTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const Gap(35),
          Column(
            children: [
              Text(
                'Dr. Maria Santos',
                style: ginaTheme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Text(
                    '10:00 AM',
                    style: ginaTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: GinaAppTheme.lightOutline,
                    ),
                  ),
                  const Gap(5),
                  Text('•', style: ginaTheme.textTheme.titleMedium),
                  const Gap(5),
                  Text(
                    'Online',
                    style: ginaTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: GinaAppTheme.lightTertiaryContainer,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
