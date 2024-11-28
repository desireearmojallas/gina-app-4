import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/admin_features/admin_patient_list/2_views/bloc/admin_patient_list_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_patient_list/2_views/screens/view_states/admin_patient_list_loaded_state.dart';

class AdminPatientListScreenProvider extends StatelessWidget {
  const AdminPatientListScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AdminPatientListBloc>(),
      child: const AdminPatientListScreen(),
    );
  }
}

class AdminPatientListScreen extends StatelessWidget {
  const AdminPatientListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      // body: AdminPatientListLoaded(
      //   patientList: state.patients,
      // ),
    );
  }
}
