import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gina_app_4/core/reusable_widgets/custom_loading_indicator.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/gina_patient_app_bar/gina_patient_app_bar.dart';
import 'package:gina_app_4/dependencies_injection.dart';
import 'package:gina_app_4/features/patient_features/cycle_history/2_views/bloc/cycle_history_bloc.dart';
import 'package:gina_app_4/features/patient_features/cycle_history/2_views/screens/view_states/cycle_history_initial_screen.dart';

class CycleHistoryScreenProvider extends StatelessWidget {
  const CycleHistoryScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CycleHistoryBloc>(
      create: (context) {
        final cycleHistoryBloc = sl<CycleHistoryBloc>();

        cycleHistoryBloc.add(GetCycleHistoryEvent());

        return cycleHistoryBloc;
      },
      child: const CycleHistoryScreen(),
    );
  }
}

class CycleHistoryScreen extends StatelessWidget {
  const CycleHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GinaPatientAppBar(title: 'Cycle History'),
      body: BlocConsumer<CycleHistoryBloc, CycleHistoryState>(
        listenWhen: (previous, current) => current is CycleHistoryActionState,
        buildWhen: (previous, current) => current is! CycleHistoryActionState,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is CycleHistoryLoaded) {
            final cycleHistoryList = state.cycleHistoryList;
            final averageCycleLengthOfPatient =
                state.averageCycleLengthOfPatient;
            final getLastPeriodDateOfPatient = state.getLastPeriodDateOfPatient;
            final getLastPeriodLengthOfPatient =
                state.getLastPeriodLengthOfPatient;
            return CycleHistoryInitialScreen(
              cycleHistoryList: cycleHistoryList,
              averageCycleLengthOfPatient: averageCycleLengthOfPatient,
              getLastPeriodDateOfPatient: getLastPeriodDateOfPatient,
              getLastPeriodLengthOfPatient: getLastPeriodLengthOfPatient,
            );
          } else if (state is CycleHistoryError) {
            return Text(state.message);
          } else if (state is CycleHistoryLoading) {
            return const Center(
              child: CustomLoadingIndicator(),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
