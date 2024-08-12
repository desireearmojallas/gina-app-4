import 'package:flutter/material.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/gina_patient_app_bar/gina_patient_app_bar.dart';
import 'package:gina_app_4/features/patient_features/appointment/2_views/screens/view_states/appointment_screen_loaded.dart';

class AppointmentScreenProvider extends StatelessWidget {
  const AppointmentScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppointmentScreen();
  }
}

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GinaPatientAppBar(
        title: 'Appointments',
      ),
      body: const AppointmentScreenLoaded(),
    );
  }
}
