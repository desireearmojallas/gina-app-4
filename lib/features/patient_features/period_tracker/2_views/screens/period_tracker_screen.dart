import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/gina_patient_app_bar/gina_patient_app_bar.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/bloc/period_tracker_bloc.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/screens/view_states/period_tracker_edit_dates_screen.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/screens/view_states/period_tracker_initial_screen.dart';

class PeriodTrackerScreenProvider extends StatelessWidget {
  const PeriodTrackerScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PeriodTrackerBloc>(
      create: (context) {
        final periodTrackerBloc = sl<PeriodTrackerBloc>();

        return periodTrackerBloc;
      },
      child: const PeriodTrackerScreen(),
    );
  }
}

class PeriodTrackerScreen extends StatelessWidget {
  const PeriodTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<PeriodTrackerBloc>();
    return Scaffold(
        appBar: GinaPatientAppBar(
          title: 'Period Tracker',
        ),
        body: BlocConsumer<PeriodTrackerBloc, PeriodTrackerState>(
          listenWhen: (previous, current) =>
              current is PeriodTrackerActionState,
          buildWhen: (previous, current) =>
              current is! PeriodTrackerActionState,
          listener: (context, state) {},
          builder: (context, state) {
            if (state is NavigateToPeriodTrackerEditDatesState) {
              return const PeriodTrackerEditDatesScreen();
            }
            return const PeriodTrackerInitialScreen();
          },
        ));
  }
}
