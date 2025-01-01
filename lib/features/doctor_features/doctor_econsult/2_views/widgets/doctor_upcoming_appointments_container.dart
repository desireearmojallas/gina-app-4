import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/bloc/doctor_consultation_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/2_views/bloc/doctor_econsult_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_upcoming_appointments/2_views/bloc/doctor_upcoming_appointments_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/appointment_status_container.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:icons_plus/icons_plus.dart';

class DoctorUpcomingAppointmentsContainer extends StatelessWidget {
  final String patientName;
  final String appointmentId;
  final String date;
  final String time;
  final String appointmentType;
  final int appointmentStatus;
  final AppointmentModel appointment;
  const DoctorUpcomingAppointmentsContainer({
    super.key,
    required this.patientName,
    required this.appointmentId,
    required this.date,
    required this.time,
    required this.appointmentType,
    required this.appointmentStatus,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    final appointmentsBloc = context.read<AppointmentBloc>();
    final doctorEConsultBloc = context.read<DoctorEconsultBloc>();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final ginaTheme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        // isFromAppointmentTabs = true;
        // appointmentsBloc.add(NavigateToAppointmentDetailsEvent(
        //   doctorUid: appointment.doctorUid!,
        //   appointmentUid: appointment.appointmentUid!,
        // ));

        HapticFeedback.mediumImpact();

        selectedPatientUid = appointment.patientUid!;
        debugPrint(
            'doctor_upcoming_appointments_container selectedPatientUid: $selectedPatientUid');

        debugPrint(
            'doctor_upcoming_appointments_container appointment: ${appointment.appointmentUid}');

        doctorEConsultBloc
            .add(GetPatientDataEvent(patientUid: appointment.patientUid!));

        isFromChatRoomLists = false;

        selectedPatientAppointment = appointment.appointmentUid;
        selectedPatientUid = appointment.patientUid ?? '';
        selectedPatientName = appointment.patientName ?? '';

        appointmentDataFromDoctorUpcomingAppointmentsBloc = appointment;
        debugPrint(
            'doctor_upcoming_appointments_container appointmentDataFromDoctorUpcomingAppointmentsBloc: $appointmentDataFromDoctorUpcomingAppointmentsBloc');

        Navigator.pushNamed(context, '/doctorOnlineConsultChat').then((value) =>
            context
                .read<DoctorEconsultBloc>()
                .add(GetRequestedEconsultsDisplayEvent()));
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
                        Images.patientProfileIcon,
                      ),
                      backgroundColor: Colors.white,
                    ),
                    const Gap(15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: width * 0.4,
                          child: Flexible(
                            child: Text(
                              patientName,
                              style: ginaTheme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.visible,
                              softWrap: true,
                            ),
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
                      appointmentStatus: appointmentStatus,
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
