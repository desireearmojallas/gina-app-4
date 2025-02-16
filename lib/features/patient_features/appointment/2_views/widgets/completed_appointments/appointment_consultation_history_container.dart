import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/appointment_status_container.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:intl/intl.dart';

class AppointmentConsultationHistoryContainer extends StatelessWidget {
  final AppointmentModel appointment;
  final bool? isDoctor;
  const AppointmentConsultationHistoryContainer({
    super.key,
    required this.appointment,
    this.isDoctor = false,
  });

  @override
  Widget build(BuildContext context) {
    final appointmentBloc = context.read<AppointmentBloc>();
    final width = MediaQuery.of(context).size.width;
    final ginaTheme = Theme.of(context);

    // Add debug prints to check for null values
    debugPrint('Appointment Date: ${appointment.appointmentDate}');
    debugPrint('Doctor UID: ${appointment.doctorUid}');
    debugPrint('Appointment UID: ${appointment.appointmentUid}');
    debugPrint('Doctor Name: ${appointment.doctorName}');
    debugPrint('Appointment Time: ${appointment.appointmentTime}');
    debugPrint('Mode of Appointment: ${appointment.modeOfAppointment}');
    debugPrint('Appointment Status: ${appointment.appointmentStatus}');

    // Add null checks
    if (appointment.appointmentDate == null ||
        appointment.doctorUid == null ||
        appointment.appointmentUid == null ||
        appointment.doctorName == null ||
        appointment.appointmentTime == null ||
        appointment.modeOfAppointment == null ||
        appointment.appointmentStatus == null) {
      return const Center(
        child: Text('Invalid appointment data'),
      );
    }

    final date = DateFormat('MMMM d, yyyy').parse(appointment.appointmentDate!);
    final month = DateFormat('MMM').format(date);
    final day = DateFormat('d').format(date);

    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();

        isDoctor == true
            ? {
                debugPrint('isDoctor is true'),
                null,
              }

            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => CompletedAppointmentDetailedScreenState(
            //         appointment: appointment,
            //         patientData: state.patientData!,
            //         completedAppointments:
            //             state.completedAppointmentsForPatientData,
            //       ),
            //     ),
            //   )
            : appointmentBloc.add(NavigateToAppointmentDetailsEvent(
                doctorUid: appointment.doctorUid!,
                appointmentUid: appointment.appointmentUid!,
              ));
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
                            appointment.appointmentTime!,
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
