import 'package:flutter/widgets.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/auth/0_model/user_model.dart';
import 'package:gina_app_4/features/patient_features/book_appointment/0_model/appointment_model.dart';

class ReviewAppointmentInitialScreen extends StatelessWidget {
  final DoctorModel doctorDetails;
  final UserModel currentPatient;
  final AppointmentModel appointmentModel;
  const ReviewAppointmentInitialScreen({
    super.key,
    required this.doctorDetails,
    required this.currentPatient,
    required this.appointmentModel,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Review Appointment Initial Screensss'),
    );
  }
}
