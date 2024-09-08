import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/appointment_status_container.dart';

class UpcomingAppointmentsContainer extends StatelessWidget {
  const UpcomingAppointmentsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final ginaTheme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        debugPrint('test');
      },
      child: Container(
        width: width / 1.05,
        height: height * 0.09,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            GinaAppTheme.defaultBoxShadow,
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Oct',
                    style: ginaTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '20',
                    style: ginaTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const Gap(35),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Dr. Maria Santos',
                    style: ginaTheme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
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
              const Spacer(),
              const AppointmentStatusContainer(
                appointmentStatus: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
