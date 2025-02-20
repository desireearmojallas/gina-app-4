import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/2_views/bloc/book_appointment_bloc.dart';

class AppointmentInformationContainer extends StatelessWidget {
  final AppointmentModel appointment;
  final UserModel currentPatient;
  const AppointmentInformationContainer({
    super.key,
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

    return Padding(
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
