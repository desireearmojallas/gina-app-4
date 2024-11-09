import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forums/2_views/bloc/doctor_forums_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_forums/2_views/screens/view_states/doctor_forums_screen_loaded.dart';

class DoctorForumsScreenProvider extends StatelessWidget {
  const DoctorForumsScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorForumsBloc>(
      create: (context) => sl<DoctorForumsBloc>(),
      child: const DoctorForumsScreen(),
    );
  }
}

class DoctorForumsScreen extends StatelessWidget {
  const DoctorForumsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DoctorForumsScreenLoaded();
  }
}
