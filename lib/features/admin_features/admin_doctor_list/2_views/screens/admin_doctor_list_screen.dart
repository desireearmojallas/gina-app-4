import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_list/2_views/bloc/admin_doctor_list_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_list/2_views/screens/view_states/admin_doctor_loaded_state.dart';

class AdminDoctorListScreenProvider extends StatelessWidget {
  const AdminDoctorListScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AdminDoctorListBloc>(),
      child: const AdminDoctorListScreen(),
    );
  }
}

class AdminDoctorListScreen extends StatelessWidget {
  const AdminDoctorListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AdminDoctorListLoaded(),
    );
  }
}
