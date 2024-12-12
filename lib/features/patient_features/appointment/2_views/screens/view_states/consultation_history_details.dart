import 'package:flutter/material.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';

class ConsultationHistoryDetailScreen extends StatelessWidget {
  final DoctorModel doctorDetails;
  final AppointmentModel appointment;
  final UserModel currentPatient;
  final List<String> prescriptionImages;
  const ConsultationHistoryDetailScreen({
    super.key,
    required this.doctorDetails,
    required this.appointment,
    required this.currentPatient,
    required this.prescriptionImages,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
