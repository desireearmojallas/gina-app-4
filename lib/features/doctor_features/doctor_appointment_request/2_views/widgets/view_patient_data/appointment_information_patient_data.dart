import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class AppointmentInformationPatientData extends StatelessWidget {
  const AppointmentInformationPatientData({super.key});

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
        height: size.height * 0.21,
        width: size.width / 1.05,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
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
                          label: 'Appointment ID',
                          value: '1234567890',
                          labelStyle: labelStyle,
                          textStyle: textStyle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 45.0),
                        child: appointmentInformationWidget(
                          label: 'Mode of Appointment',
                          value: 'Online Consultation',
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
                          label: 'Date',
                          value: 'December 19, 2024 Tuesday',
                          labelStyle: labelStyle,
                          textStyle: textStyle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 45.0),
                        child: appointmentInformationWidget(
                          label: 'Time',
                          value: '8:00 AM - 9:00 AM',
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: labelStyle,
        ),
        const Gap(5),
        Text(
          value,
          style: textStyle,
        ),
      ],
    );
  }
}
