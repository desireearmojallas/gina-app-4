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
    String appointmentData = appointment.appointmentDate!;
    DateTime appointmentDate =
        DateFormat('MMMM dd, yyyy').parse(appointmentData);
    String abbreviatedMonth = DateFormat('MMM').format(appointmentDate);
    int day = appointmentDate.day;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final ginaTheme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        debugPrint('test');
      },
      child: Column(
        children: [
          Container(
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
                        abbreviatedMonth,
                        style: ginaTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        day.toString(),
                        style: ginaTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const Gap(30),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width * 0.45,
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                'Dr. ${appointment.doctorName}',
                                style: ginaTheme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.visible,
                                softWrap: true,
                              ),
                            ),
                            const Gap(5),
                            const Icon(
                              Icons.verified_rounded,
                              color: GinaAppTheme.verifiedColor,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            appointment.appointmentTime!,
                            style: ginaTheme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: GinaAppTheme.lightOutline,
                            ),
                          ),
                          const Gap(5),
                          Text('•',
                              style: ginaTheme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: GinaAppTheme.lightOutline,
                              )),
                          const Gap(5),
                          Text(
                            appointment.modeOfAppointment == 0
                                ? 'Online'
                                : 'Face-to-face',
                            style: ginaTheme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: GinaAppTheme.lightTertiaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  AppointmentStatusContainer(
                    appointmentStatus: appointment.appointmentStatus,
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
