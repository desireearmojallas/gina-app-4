import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/appointment_status_container.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:intl/intl.dart';

class AppointmentConsultationHistoryContainer extends StatelessWidget {
  final AppointmentModel appointment;
  const AppointmentConsultationHistoryContainer({
    super.key,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final ginaTheme = Theme.of(context);

    final date = DateFormat('MMMM d, yyyy').parse(appointment.appointmentDate!);
    final month = DateFormat('MMM').format(date);
    final day = DateFormat('d').format(date);

    return GestureDetector(
      onTap: () {
        debugPrint('test');
      },
      child: Column(
        children: [
          Container(
            width: width / 1.05,
            // height: height * 0.1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: [
                GinaAppTheme.defaultBoxShadow,
              ],
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 15.0),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        month,
                        style: ginaTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        day,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width * 0.4,
                        child: Text(
                          'Appt ID: ${appointment.appointmentUid}',
                          style: ginaTheme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 9.5,
                            color: GinaAppTheme.lightOutline,
                          ),
                        ),
                      ),
                      const Gap(5),
                      SizedBox(
                        width: width * 0.4,
                        child: Flexible(
                          child: Text(
                            'Dr. ${appointment.doctorName}',
                            style: ginaTheme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '10:00 AM',
                            style: ginaTheme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: GinaAppTheme.lightOutline,
                              fontSize: 10,
                            ),
                          ),
                          const Gap(5),
                          Text('•', style: ginaTheme.textTheme.titleSmall),
                          const Gap(5),
                          Text(
                            appointment.modeOfAppointment == 0
                                ? 'Online'
                                : 'Face-to-face',
                            style: ginaTheme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: GinaAppTheme.lightTertiaryContainer,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  AppointmentStatusContainer(
                    appointmentStatus: appointment.appointmentStatus!,
                  ),
                ],
              ),
            ),
          ),
          const Gap(10),
        ],
      ),
    );
  }
}
