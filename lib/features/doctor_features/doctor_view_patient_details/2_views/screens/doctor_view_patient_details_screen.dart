import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_view_patient_details/2_views/bloc/doctor_view_patient_details_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_view_patient_details/2_views/screens/view_states/doctor_view_patient_details_screen_loaded.dart';

class DoctorViewPatientDetailsScreenProvider extends StatelessWidget {
  const DoctorViewPatientDetailsScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorViewPatientDetailsBloc>(
      create: (context) => sl<DoctorViewPatientDetailsBloc>(),
      child: const DoctorViewPatientDetailsScreen(),
    );
  }
}

class DoctorViewPatientDetailsScreen extends StatelessWidget {
  const DoctorViewPatientDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient data'),
      ),
      body: const DoctorViewPatientDetailsScreenLoaded(),
    );
  }
}
