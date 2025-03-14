import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
import 'package:gina_app_4/core/reusable_widgets/gradient_background.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/widgets/view_patient_data/view_patient_data.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation/2_views/bloc/doctor_consultation_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/2_views/bloc/doctor_econsult_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_upcoming_appointments/2_views/bloc/doctor_upcoming_appointments_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_view_patients/2_views/bloc/doctor_view_patients_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/appointment_status_container.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';
import 'package:icons_plus/icons_plus.dart';

class ApprovedRequestDetailsScreenState extends StatelessWidget {
  final AppointmentModel appointment;
  final UserModel patientData;
  final int? appointmentStatus;
  final List<AppointmentModel> completedAppointments;
  final List<PeriodTrackerModel> patientPeriods;
  const ApprovedRequestDetailsScreenState({
    super.key,
    required this.appointment,
    required this.patientData,
    this.appointmentStatus = 1,
    required this.completedAppointments,
    required this.patientPeriods,
  });

  @override
  Widget build(BuildContext context) {
    final doctorEConsultBloc = context.read<DoctorEconsultBloc>();
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context);

    debugPrint('Patient Name: ${patientData.name}');
    debugPrint('Patient Date of Birth: ${patientData.dateOfBirth}');
    debugPrint('Patient Gender: ${patientData.gender}');
    debugPrint('Patient Address: ${patientData.address}');
    debugPrint('Patient Email: ${patientData.email}');

    final labelStyle = ginaTheme.textTheme.bodySmall?.copyWith(
      color: GinaAppTheme.lightOutline,
    );
    final textStyle = ginaTheme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w600,
    );

    final divider = Column(
      children: [
        const Gap(5),
        SizedBox(
          width: size.width / 1.15,
          child: const Divider(
            thickness: 0.5,
            color: GinaAppTheme.lightSurfaceVariant,
          ),
        ),
        const Gap(25),
      ],
    );

    return Scaffold(
      appBar: GinaDoctorAppBar(
        title: patientData.name,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: FloatingActionButton(
          onPressed: () {
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
            selectedPatientAppointmentModel = appointment;

            appointmentDataFromDoctorUpcomingAppointmentsBloc = appointment;
            debugPrint(
                'doctor_upcoming_appointments_container appointmentDataFromDoctorUpcomingAppointmentsBloc: $appointmentDataFromDoctorUpcomingAppointmentsBloc');

            Navigator.pushNamed(context, '/doctorOnlineConsultChat').then(
                (value) => context
                    .read<DoctorEconsultBloc>()
                    .add(GetRequestedEconsultsDisplayEvent()));
          },
          backgroundColor: GinaAppTheme.lightTertiaryContainer,
          child: const Icon(
            MingCute.message_3_fill,
            color: GinaAppTheme.lightBackground,
          ),
        ),
      ),
      body: Stack(
        children: [
          const GradientBackground(),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Container(
                height: size.height * 0.81,
                width: size.width / 1.05,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: GinaAppTheme.lightOnTertiary,
                  boxShadow: [
                    GinaAppTheme.defaultBoxShadow,
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 30, 15, 20),
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage(
                              Images.patientProfileIcon,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: size.width * 0.5,
                              child: Text(
                                patientData.name,
                                style: ginaTheme.textTheme.titleSmall?.copyWith(
                                  color: GinaAppTheme.lightOnBackground,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.5,
                              child: Flexible(
                                child: Text(
                                  'Appointment ID: ${appointment.appointmentUid}',
                                  style:
                                      ginaTheme.textTheme.labelSmall?.copyWith(
                                    color: GinaAppTheme.lightOutline,
                                  ),
                                  overflow: TextOverflow.visible,
                                  softWrap: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                        //const Spacer(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 20, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppointmentStatusContainer(
                                appointmentStatus:
                                    // appointment.appointmentStatus,
                                    appointmentStatus!,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Birth date',
                                style: labelStyle,
                              ),
                              const Gap(10),
                              Text(
                                patientData.dateOfBirth,
                                style: textStyle,
                              ),
                            ],
                          ),
                          const Gap(130),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Gender',
                                style: labelStyle,
                              ),
                              const Gap(10),
                              Text(
                                patientData.gender,
                                style: textStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    divider,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Address',
                              style: labelStyle,
                            ),
                            const Gap(10),
                            Text(
                              patientData.address,
                              style: textStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                    divider,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email address',
                              style: labelStyle,
                            ),
                            const Gap(10),
                            Text(
                              patientData.email,
                              style: textStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                    divider,
                    const Gap(20),
                    Container(
                      height: size.height * 0.08,
                      width: size.width / 1.12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: GinaAppTheme.lightSurfaceVariant,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            appointment.modeOfAppointment == 0
                                ? 'Online Consultation'.toUpperCase()
                                : 'Face-to-Face Consultation'.toUpperCase(),
                            style: ginaTheme.textTheme.labelSmall?.copyWith(
                              color: GinaAppTheme.lightTertiaryContainer,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Gap(5),
                          Text(
                            '${appointment.appointmentDate} | ${appointment.appointmentTime}',
                            style: ginaTheme.textTheme.labelMedium?.copyWith(
                              color: GinaAppTheme.lightOutline,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(50),
                    TextButton(
                      onPressed: () {
                        // Navigator.pushNamed(context, '/viewPatientData');

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewPatientDataScreen(
                                      patient: patientData,
                                      patientAppointment: appointment,
                                      patientAppointments:
                                          completedAppointments,
                                      patientPeriods: patientPeriods,
                                    )));
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'View Patient Data',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Gap(10),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 50, 15, 20),
                      child: Container(
                        height: size.height * 0.06,
                        width: size.width / 1.15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: GinaAppTheme.approvedTextColor,
                        ),
                        child: Center(
                          child: Text(
                            'Approved',
                            style: ginaTheme.textTheme.labelLarge?.copyWith(
                              color: GinaAppTheme.lightBackground,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
