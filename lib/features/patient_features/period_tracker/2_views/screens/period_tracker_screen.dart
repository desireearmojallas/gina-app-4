import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/bloc/period_tracker_bloc.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/screens/view_states/period_tracker_initial_screen.dart';

class PeriodTrackerScreenProvider extends StatelessWidget {
  const PeriodTrackerScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PeriodTrackerBloc>(
      create: (context) => sl<PeriodTrackerBloc>(),
      child: const PeriodTrackerScreen(),
    );
  }
}

class PeriodTrackerScreen extends StatelessWidget {
  const PeriodTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PeriodTrackerInitialScreen();
  }
}
