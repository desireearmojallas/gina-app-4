import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/gina_divider.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_emergency_announcements/2_views/widgets/dashed_line_painter_vertical.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/appointment_status_container.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/screens/view_states/custom_appointment_countdown.dart';
import 'package:lottie/lottie.dart';

class ConsultationWaitingAppointmentScreen extends StatelessWidget {
  final AppointmentModel appointment;
  const ConsultationWaitingAppointmentScreen(
      {super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: Image.asset(
          //     Images.splashPic,
          //     fit: BoxFit.cover,
          //   ),
          // ),
          Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Text(
                //   'Appointment with\n${appointment.patientName}',
                //   style: ginaTheme.titleLarge?.copyWith(
                //     fontSize: 20,
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),
                AppointmentCard(
                  size: size,
                  appointment: appointment,
                  ginaTheme: ginaTheme,
                ),
                GinaDivider(
                  space: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: size.width * 0.85,
                      child: Flexible(
                        child: Text(
                          'Countdown to ${appointment.patientName}\'s consultation',
                          style: ginaTheme.bodyMedium?.copyWith(
                            // fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.visible,
                          softWrap: true,
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap(5),
                AppointmentCountdown(
                  appointment: appointment,
                  onCountdownComplete: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Appointment Time Reached'),
                            content: const Text(
                                'Your appointment time has reached. Please proceed to the consultation room.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        });
                  },
                ),
                const Gap(30),
                Padding(
                  padding: const EdgeInsets.only(right: 80.0),
                  child: Lottie.network(
                    'https://lottie.host/f5cdd338-d7e0-44d1-850f-849ace6835d3/lT5Yt3AwJq.json',
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text(
                        'Failed to load animation',
                        style: TextStyle(color: Colors.red),
                      );
                    },
                  ),
                ),
                const Gap(25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    'Your consultation will begin soon. Please stay tuned for the countdown.',
                    style: ginaTheme.bodyMedium?.copyWith(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Gap(25),
                Container(
                  height: size.height * 0.06,
                  width: size.width * 0.9,
                  margin: const EdgeInsets.only(bottom: 30),
                  child: FilledButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Ok',
                      style: ginaTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    super.key,
    required this.size,
    required this.appointment,
    required this.ginaTheme,
  });

  final Size size;
  final AppointmentModel appointment;
  final TextTheme ginaTheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
      child: IntrinsicHeight(
        child: Container(
          width: size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              GinaAppTheme.defaultBoxShadow,
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Appointment Details'.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(10),
                        Text(
                          appointment.modeOfAppointment == 0
                              ? 'Online Consultation'.toUpperCase()
                              : 'Face-to-face Consultation'.toUpperCase(),
                          style: const TextStyle(
                            color: GinaAppTheme.lightTertiaryContainer,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    AppointmentStatusContainer(
                      appointmentStatus: appointment.appointmentStatus,
                    ),
                  ],
                ),
                const Gap(20),
                Text(
                  'Appointment ID: ${appointment.appointmentUid}',
                  style: ginaTheme.labelMedium?.copyWith(
                    color: GinaAppTheme.lightOutline,
                    fontSize: 10.0,
                  ),
                  maxLines: null,
                ),
                const Gap(10),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.2,
                              child: const Text(
                                'Patient name',
                                style: TextStyle(
                                  color: GinaAppTheme.lightOutline,
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Gap(5),
                            SizedBox(
                              width: size.width * 0.3,
                              child: Flexible(
                                child: Text(
                                  appointment.patientName!,
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(10),
                        Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.2,
                              child: const Text(
                                'Doctor name',
                                style: TextStyle(
                                  color: GinaAppTheme.lightOutline,
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Gap(5),
                            SizedBox(
                              width: size.width * 0.3,
                              child: Flexible(
                                child: Text(
                                  'Dr. ${appointment.doctorName}',
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    CustomPaint(
                      size: Size(1, size.height * 0.05),
                      painter: DashedLinePainterVertical(
                        color: Colors.grey,
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text(
                              appointment.appointmentTime!,
                              style: const TextStyle(
                                fontSize: 10.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const Gap(10),
                        Row(
                          children: [
                            Text(
                              appointment.appointmentDate!,
                              style: const TextStyle(
                                fontSize: 10.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const Gap(5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
