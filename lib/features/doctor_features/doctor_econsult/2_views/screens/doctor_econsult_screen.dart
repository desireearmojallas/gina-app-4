import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/2_views/bloc/doctor_econsult_bloc.dart';
import 'package:gina_app_4/features/doctor_features/doctor_econsult/2_views/screens/view_states/doctor_econsult_screen_loaded.dart';

class DoctorEConsultScreenProvider extends StatelessWidget {
  const DoctorEConsultScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorEconsultBloc>(
      create: (context) => sl<DoctorEconsultBloc>(),
      child: const DoctorEConsultScreen(),
    );
  }
}

class DoctorEConsultScreen extends StatelessWidget {
  const DoctorEConsultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorEconsultBloc, DoctorEconsultState>(
      listener: (context, state) {},
      builder: (context, state) {
        return const DoctorEConsultScreenLoaded();
      },
    );
  }
}
