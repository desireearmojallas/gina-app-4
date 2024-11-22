import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_view_patients/2_views/bloc/doctor_view_patients_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_view_patients/2_views/screens/view_states/doctor_view_patients_screen_loaded.dart';

class DoctorViewPatientsScreenProvider extends StatelessWidget {
  const DoctorViewPatientsScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorViewPatientsBloc>(
      create: (context) => sl<DoctorViewPatientsBloc>(),
      child: const DoctorViewPatientsScreen(),
    );
  }
}

class DoctorViewPatientsScreen extends StatelessWidget {
  const DoctorViewPatientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients list'),
      ),
      body: const DoctorViewPatientsScreenLoaded(),
    );
  }
}
