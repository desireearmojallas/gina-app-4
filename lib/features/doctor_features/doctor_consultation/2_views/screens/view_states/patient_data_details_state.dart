import 'package:flutter/material.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';

class PatientDataScreenState extends StatelessWidget {
  final UserModel patient;
  final List<PeriodTrackerModel> patientPeriods;
  final AppointmentModel patientAppointment;
  final List<AppointmentModel> patientAppointments;
  const PatientDataScreenState({
    super.key,
    required this.patient,
    required this.patientPeriods,
    required this.patientAppointment,
    required this.patientAppointments,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
