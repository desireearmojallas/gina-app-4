import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/appointment_status_container.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/bloc/consultation_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class UpcomingAppointmentsContainer extends StatelessWidget {
  final String doctorName;
  final String appointmentId;
  final String date;
  final String time;
  final String appointmentType;
  final int appointmentStatus;
  final AppointmentModel appointment;
  const UpcomingAppointmentsContainer({
    super.key,
    required this.doctorName,
    required this.appointmentId,
    required this.date,
    required this.time,
    required this.appointmentType,
    required this.appointmentStatus,
    required this.appointment,
  });

  bool isOngoing(AppointmentModel appointment) {
    final today = DateFormat('MMMM d, yyyy').format(DateTime.now());
    if (appointment.appointmentDate != today) return false;

    final times = appointment.appointmentTime?.split(' - ');
    if (times?.length != 2) return false;

    final startTime = DateFormat('h:mm a').parse(times![0]);
    final endTime = DateFormat('h:mm a').parse(times[1]);

    final appointmentStartDateTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      startTime.hour,
      startTime.minute,
    );
    final appointmentEndDateTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      endTime.hour,
      endTime.minute,
    );

    final now = DateTime.now();
    return now.isAfter(appointmentStartDateTime) &&
        now.isBefore(appointmentEndDateTime);
  }

  @override
  Widget build(BuildContext context) {
    final appointmentsBloc = context.read<AppointmentBloc>();
    // final consultationBloc = context.read<ConsultationBloc>();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final ginaTheme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        isFromAppointmentTabs = true;

        selectedDoctorAppointmentModel = appointment;

        appointmentsBloc.add(NavigateToAppointmentDetailsEvent(
          doctorUid: appointment.doctorUid!,
          appointmentUid: appointment.appointmentUid!,
        ));
        // Navigator.pushNamed(context, '/appointments');
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            GinaAppTheme.defaultBoxShadow,
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(height * 0.029),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage(
                        Images.doctorProfileIcon3,
                      ),
                      backgroundColor: Colors.white,
                    ),
                    const Gap(15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: width * 0.4,
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  'Dr. $doctorName',
                                  style:
                                      ginaTheme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.visible,
                                  softWrap: true,
                                ),
                              ),
                              const Gap(8),
                              const Icon(
                                Bootstrap.patch_check_fill,
                                color: Colors.white,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: width * 0.35,
                          child: Text(
                            'ID: $appointmentId',
                            style: ginaTheme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Gap(35),
                    AppointmentStatusContainer(
                      appointmentStatus:
                          isOngoing(appointment) ? 6 : appointmentStatus,
                      colorOverride: Colors.white,
                    ),
                  ],
                ),
                const Gap(30),
                Container(
                  width: width * 0.8,
                  height: height * 0.03,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white.withOpacity(0.3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              MingCute.calendar_2_line,
                              color: Colors.white,
                              size: 18,
                            ),
                            const Gap(5),
                            Text(
                              date,
                              style: ginaTheme.textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              MingCute.time_line,
                              color: Colors.white,
                              size: 16,
                            ),
                            const Gap(5),
                            Text(
                              time,
                              style: ginaTheme.textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              MingCute.message_3_line,
                              color: Colors.white,
                              size: 16,
                            ),
                            const Gap(5),
                            Text(
                              appointmentType,
                              style: ginaTheme.textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
