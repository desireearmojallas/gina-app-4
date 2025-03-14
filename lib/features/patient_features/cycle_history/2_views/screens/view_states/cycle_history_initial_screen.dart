import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/features/patient_features/cycle_history/2_views/widgets/cycle_history_header.dart';
import 'package:gina_app_4/features/patient_features/cycle_history/2_views/widgets/last_cycle_dates_container.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';

class CycleHistoryInitialScreen extends StatelessWidget {
  final List<PeriodTrackerModel>? cycleHistoryList;
  final int? averageCycleLengthOfPatient;
  final DateTime? getLastPeriodDateOfPatient;
  final int? getLastPeriodLengthOfPatient;

  const CycleHistoryInitialScreen(
      {super.key,
      required this.cycleHistoryList,
      required this.averageCycleLengthOfPatient,
      required this.getLastPeriodDateOfPatient,
      required this.getLastPeriodLengthOfPatient});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: SingleChildScrollView(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CycleHistoryHeader(
                getLastPeriodDateOfPatient: getLastPeriodDateOfPatient,
                getLastPeriodLengthOfPatient: getLastPeriodLengthOfPatient,
              ),
              const Gap(15),
              LastCycleDatesContainer(
                cycleHistoryList: cycleHistoryList,
                averageCycleLengthOfPatient: averageCycleLengthOfPatient,
              )
            ],
          ),
        ),
      ),
    );
  }
}
