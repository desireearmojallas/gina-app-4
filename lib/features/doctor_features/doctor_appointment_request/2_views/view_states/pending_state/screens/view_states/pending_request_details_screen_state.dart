import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
import 'package:gina_app_4/core/reusable_widgets/gradient_background.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/view_states/pending_state/widgets/confirming_pending_request_modal.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/widgets/view_patient_data/view_patient_data.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/appointment_status_container.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';

class PendingRequestDetailsScreenState extends StatelessWidget {
  final AppointmentModel appointment;
  final UserModel patientData;

  const PendingRequestDetailsScreenState({
    super.key,
    required this.appointment,
    required this.patientData,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context);

    final labelStyle = ginaTheme.textTheme.bodySmall?.copyWith(
      color: GinaAppTheme.lightOutline,
    );
    final textStyle = ginaTheme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w600,
    );

    final divider = Column(children: [
      const Gap(5),
      SizedBox(
        width: size.width / 1.15,
        child: const Divider(
          thickness: 0.5,
          color: GinaAppTheme.lightSurfaceVariant,
        ),
      ),
      const Gap(25),
    ]);

    return Scaffold(
      appBar: GinaDoctorAppBar(
        title: patientData.name,
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 20, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppointmentStatusContainer(
                                appointmentStatus:
                                    appointment.appointmentStatus,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(25),
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
                        //TODO: For testing only patient data routing
                        //! for testing only
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewPatientDataScreen(
                                      patient: patientData,
                                      patientAppointment: appointment,
                                      patientAppointments: patientData
                                          .appointmentsBooked
                                          .map((appointmentId) =>
                                              AppointmentModel(
                                                  appointmentUid:
                                                      appointmentId))
                                          .toList(),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: size.height * 0.05,
                            width: size.width / 2.4,
                            child: FilledButton(
                              onPressed: () {
                                showConfirmingPendingRequestDialog(
                                  context,
                                  appointmentId: appointment.appointmentUid!,
                                  patientData: patientData,
                                  appointment: appointment,
                                );
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                  GinaAppTheme.lightSurfaceVariant,
                                ),
                              ),
                              child: const Text(
                                'Decline',
                                style: TextStyle(
                                  color: GinaAppTheme.lightOnBackground,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.05,
                            width: size.width / 2.4,
                            child: FilledButton(
                              onPressed: () {
                                showConfirmingPendingRequestDialog(
                                  context,
                                  appointmentId: appointment.appointmentUid!,
                                  patientData: patientData,
                                  appointment: appointment,
                                );
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Approve',
                              ),
                            ),
                          ),
                        ],
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
