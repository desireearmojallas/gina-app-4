import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/bloc/admin_doctor_verification_bloc.dart';
import 'package:gina_app_4/features/admin_features/admin_doctor_verification/2_views/screens/view_states/admin_doctor_verification_initial_state.dart';

class AdminVerifyDoctorScreenProvider extends StatelessWidget {
  const AdminVerifyDoctorScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminDoctorVerificationBloc>(
      create: (context) => sl<AdminDoctorVerificationBloc>(),
      child: const AdminDoctorVerifyScreen(),
    );
  }
}

class AdminDoctorVerifyScreen extends StatelessWidget {
  const AdminDoctorVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AdminDoctorVerificationInitialState(),
    );
  }
}
