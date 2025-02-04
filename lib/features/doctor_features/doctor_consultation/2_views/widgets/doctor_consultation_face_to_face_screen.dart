import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/consultation/2_views/screens/view_states/consultation_waiting_appointment.dart';

class DoctorConsultationFaceToFaceScreen extends StatelessWidget {
  final AppointmentModel patientAppointment;
  const DoctorConsultationFaceToFaceScreen(
      {super.key, required this.patientAppointment});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(
            //   'Appointment with ${patientAppointment.patientName} ',
            // ),
            AppointmentCard(
                size: size,
                appointment: patientAppointment,
                ginaTheme: ginaTheme),
            const Spacer(),
            SizedBox(
              width: size.width * 0.8,
              height: size.height / 17,
              child: FilledButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  'Begin',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                ),
              ),
            ),
            const Gap(30),
            SizedBox(
              width: size.width * 0.8,
              height: size.height / 17,
              child: OutlinedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  side: MaterialStateProperty.all(
                    const BorderSide(
                      color: GinaAppTheme.lightTertiaryContainer,
                    ),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  'Finish',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: GinaAppTheme.lightTertiaryContainer,
                      ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
