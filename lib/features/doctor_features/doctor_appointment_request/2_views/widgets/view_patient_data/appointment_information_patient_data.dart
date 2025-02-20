import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';

class AppointmentInformationPatientData extends StatelessWidget {
  final AppointmentModel appointment;
  const AppointmentInformationPatientData(
      {super.key, required this.appointment});

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

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Container(
        height: size.height * 0.23,
        width: size.width / 1.08,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            GinaAppTheme.defaultBoxShadow,
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 15, 0, 15),
                        child: appointmentInformationWidget(
                          context: context,
                          label: 'Appointment ID',
                          value: appointment.appointmentUid!,
                          labelStyle: labelStyle,
                          textStyle: textStyle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 45.0),
                        child: appointmentInformationWidget(
                          context: context,
                          isModeOfAppointment: true,
                          label: 'Mode of Appointment',
                          value: appointment.modeOfAppointment == 0
                              ? 'Online Consultation'
                              : 'Face-to-Face Consultation',
                          labelStyle: labelStyle,
                          textStyle: textStyle,
                        ),
                      ),
                    ],
                  ),
                  divider,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: appointmentInformationWidget(
                          context: context,
                          label: 'Date',
                          // value: 'December 19, 2024 Tuesday',
                          value: appointment.appointmentDate!,

                          labelStyle: labelStyle,
                          textStyle: textStyle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 45.0),
                        child: appointmentInformationWidget(
                          context: context,
                          label: 'Time',
                          value: appointment.appointmentTime!,
                          labelStyle: labelStyle,
                          textStyle: textStyle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget appointmentInformationWidget({
    required String label,
    required String value,
    required labelStyle,
    required textStyle,
    context,
    isModeOfAppointment = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: labelStyle,
        ),
        const Gap(5),
        isModeOfAppointment == true
            ? SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: Flexible(
                  child: Text(
                    value,
                    style: textStyle,
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                ),
              )
            : Text(
                value,
                style: textStyle,
              ),
      ],
    );
  }
}
