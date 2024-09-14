import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/appointment_consultation_history_container.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/swipeable_upcoming_appointments.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/upcoming_appointments_container.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/widgets/upcoming_appointments_container_2.dart';

class AppointmentScreenLoaded extends StatelessWidget {
  const AppointmentScreenLoaded({super.key});

  @override
  Widget build(BuildContext context) {
    List<UpcomingAppointmentsContainer2> hardCodedAppointments = [
      const UpcomingAppointmentsContainer2(
        doctorName: 'Dr. Maria Santos',
        specialty: 'Obstetrician & Gynecologist',
        date: 'Sep 15, 2024',
        time: '9:30 AM',
        appointmentType: 'Online',
        appointmentStatus: 1,
      ),
      const UpcomingAppointmentsContainer2(
        doctorName: 'Dr. John Doe',
        specialty: 'Cardiologist',
        date: 'Sep 20, 2024',
        time: '11:00 AM',
        appointmentType: 'In-Person',
        appointmentStatus: 1,
      ),
      const UpcomingAppointmentsContainer2(
        doctorName: 'Dr. Emily Brown',
        specialty: 'Dermatologist',
        date: 'Sep 25, 2024',
        time: '2:30 PM',
        appointmentType: 'Online',
        appointmentStatus: 1,
      ),
    ];

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _title(context, 'Upcoming appointments'),
                  const Gap(5),
                  const Text(
                    '(3)',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const Gap(17),
              const UpcomingAppointmentsContainer2(
                doctorName: 'Dr. Maria Santos',
                specialty: 'Obstetrician & Gynecologist',
                date: 'Sep 15, 2024',
                time: '9:30 AM',
                appointmentType: 'Online',
                appointmentStatus: 1,
              ),
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
