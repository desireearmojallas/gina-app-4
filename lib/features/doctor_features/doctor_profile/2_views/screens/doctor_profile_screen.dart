import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_profile/2_views/bloc/doctor_profile_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_profile/2_views/screens/view_states/doctor_profile_screen_loaded.dart';

class DoctorProfileScreenProvider extends StatelessWidget {
  const DoctorProfileScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorProfileBloc>(
      create: (context) => sl<DoctorProfileBloc>(),
      child: const DoctorProfileScreen(),
    );
  }
}

class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DoctorProfileScreenLoaded();
  }
}
