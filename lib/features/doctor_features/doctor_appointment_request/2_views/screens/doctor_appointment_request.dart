import 'package:flutter/material.dart';
import 'package:gina_app_4/core/reusable_widgets/doctor_reusable_widgets/gina_doctor_app_bar/gina_doctor_app_bar.dart';
import 'package:gina_app_4/features/doctor_features/doctor_appointment_request/2_views/screens/view_states/doctor_appointment_request_screen_loaded.dart';

class DoctorAppointmentRequestProvider extends StatelessWidget {
  const DoctorAppointmentRequestProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return const DoctorAppointmentRequestScreen();
  }
}

class DoctorAppointmentRequestScreen extends StatelessWidget {
  const DoctorAppointmentRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GinaDoctorAppBar(
        title: 'Appointment Requests',
      ),
      body: const DoctorAppointmentRequestScreenLoaded(),
    );
  }
}
