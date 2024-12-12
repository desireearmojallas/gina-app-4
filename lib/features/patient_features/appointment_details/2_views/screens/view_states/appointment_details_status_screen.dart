import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/2_views/widgets/doctor_name_widget.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/bloc/appointment_bloc.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/widgets/appointment_status_card.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/widgets/cancel_appointment_widgets/cancel_modal_dialog.dart';
import 'package:gina_app_4/features/patient_features/appointment_details/2_views/widgets/reschedule_filled_button.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/2_views/bloc/book_appointment_bloc.dart';

class AppointmentDetailsStatusScreen extends StatelessWidget {
  final DoctorModel doctorDetails;
  final AppointmentModel appointment;
  final UserModel currentPatient;
  const AppointmentDetailsStatusScreen({
    super.key,
    required this.doctorDetails,
    required this.appointment,
    required this.currentPatient,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;

    final labelStyle = ginaTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    final valueStyle = ginaTheme.bodyMedium?.copyWith(
      fontSize: 12,
    );

    const divider = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        width: double.infinity,
        child: Divider(
          color: GinaAppTheme.lightSurfaceVariant,
          thickness: 0.5,
        ),
      ),
    );

    final bookAppointmentBloc = context.read<BookAppointmentBloc>();

    return ScrollbarCustom(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            doctorNameWidget(size, ginaTheme, doctorDetails),
            // const Gap(20),
            AppointmentStatusCard(
              appointmentStatus: appointment.appointmentStatus,
            ),

            [2, 1].contains(appointment.appointmentStatus)
                ? const SizedBox()
                : Column(
                    children: [
                      const Gap(15),
                      RescheduleFilledButton(
                        appointmentUid:
                            appointment.appointmentUid ?? storedAppointmentUid!,
                        doctor: doctorDetails,
                      ),
                    ],
                  ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: IntrinsicHeight(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 20.0,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Appointment ID:',
                              style: labelStyle,
                            ),
                            const Gap(10),
                            Text(
                              '${appointment.appointmentUid}',
                              style: valueStyle,
                            ),
                          ],
                        ),
                        divider,
                        headerWidget(
                          Icons.medical_services_outlined,
                          'Appointment Detail',
                        ),
                        Column(
                          children: [
                            const Gap(20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Clinic location',
                                  style: labelStyle,
                                ),
                                Text(
                                  '${appointment.doctorClinicAddress}',
                                  style: valueStyle,
                                ),
                              ],
                            ),
                            const Gap(15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Mode of appointment',
                                  style: labelStyle,
                                ),
                                Text(
                                  appointment.modeOfAppointment == 0
                                      ? 'Online Consultation'
                                      : 'Face-to-Face Consultation',
                                  style: valueStyle,
                                ),
                              ],
                            ),
                            const Gap(15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Date & time',
                                  style: labelStyle,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${appointment.appointmentDate}',
                                      style: valueStyle,
                                    ),
                                    Text(
                                      '${appointment.appointmentTime}',
                                      style: valueStyle,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        divider,
                        headerWidget(
                          Icons.person_3,
                          'Patient Personal Information',
                        ),
                        Column(
                          children: [
                            const Gap(20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Name',
                                  style: labelStyle,
                                ),
                                Text(
                                  currentPatient.name,
                                  style: valueStyle,
                                ),
                              ],
                            ),
                            const Gap(15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Age',
                                  style: labelStyle,
                                ),
                                Text(
                                  '${bookAppointmentBloc.calculateAge(currentPatient.dateOfBirth)} years old',
                                  style: valueStyle,
                                ),
                              ],
                            ),
                            const Gap(15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Location',
                                  style: labelStyle,
                                ),
                                Text(
                                  currentPatient.address,
                                  style: valueStyle,
                                ),
                              ],
                            ),
                            const Gap(15),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            [2, 3, 4].contains(appointment.appointmentStatus)
                ? const SizedBox()
                : Text(
                    'To ensure a smooth online appointment, please be prepared 15 \nminutes before the scheduled time.',
                    textAlign: TextAlign.center,
                    style: ginaTheme.bodySmall?.copyWith(
                      color: GinaAppTheme.lightOutline,
                    ),
                  ),
            const Gap(15),
            [2, 3, 4].contains(appointment.appointmentStatus)
                ? const SizedBox()
                : SizedBox(
                    width: size.width * 0.93,
                    height: size.height / 17,
                    child: OutlinedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      onPressed: () {
                        showCancelModalDialog(context,
                            appointmentId: appointment.appointmentUid!);
                      },
                      child: Text(
                        'Cancel Appointment',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ),
                  ),
            const Gap(100),
          ],
        ),
      ),
    );
  }

  Widget headerWidget(
    IconData icon,
    String text,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
        ),
        const Gap(10),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
