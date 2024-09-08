import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/appointment_consultation_history_container.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/upcoming_appointments_container.dart';

class AppointmentScreenLoaded extends StatelessWidget {
  const AppointmentScreenLoaded({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _title(context, 'Upcoming appointments'),
              const Gap(17),
              const UpcomingAppointmentsContainer(),
              const Gap(30),
              _title(context, 'Consultation history'),
              const Gap(17),
              const AppointmentConsultationHistoryContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
      textAlign: TextAlign.left,
    );
  }
}
