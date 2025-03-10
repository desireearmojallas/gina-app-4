import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/bloc/period_tracker_bloc.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/screens/widgets/period_tracker_legend.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/screens/widgets/period_tracker_widgets/yearly_calendar_widget.dart';

class PeriodTrackerEditDatesScreen extends StatefulWidget {
  final List<PeriodTrackerModel> periodTrackerModel;
  final List<DateTime> storedPeriodDates;
  const PeriodTrackerEditDatesScreen({
    super.key,
    required this.periodTrackerModel,
    required this.storedPeriodDates,
  });

  @override
  _PeriodTrackerEditDatesScreenState createState() =>
      _PeriodTrackerEditDatesScreenState();
}

class _PeriodTrackerEditDatesScreenState
    extends State<PeriodTrackerEditDatesScreen> {
  List<DateTime> periodDates = [];
  List<DateTime> averageBasedPredictionDates = [];
  List<DateTime> defaultPeriodPredictions = [];

  @override
  void initState() {
    super.initState();
    periodDates = widget.storedPeriodDates;
    averageBasedPredictionDates = widget.periodTrackerModel
        .expand((p) => p.averageBasedPredictionDates)
        .toList();
    defaultPeriodPredictions = widget.periodTrackerModel
        .where((p) => p.cycleLength == 28)
        .expand((p) => p.day28PredictionDates)
        .toList();
    debugPrint('Initial stored period dates: $periodDates');
  }

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context);
    final periodTrackerBloc = context.read<PeriodTrackerBloc>();

    // Debug print to check the contents of periodTrackerModel
    debugPrint('PeriodTrackerModel: ${widget.periodTrackerModel}');

    // Check if periodTrackerModel is empty
    if (widget.periodTrackerModel.isEmpty) {
      debugPrint(
          'PeriodTrackerModel is empty. Please ensure it is populated with data.');
    }

    // Debug prints to check the extracted lists
    debugPrint('Edit date screen (period dates): $periodDates');
    debugPrint(
        'Edit date screen (average-based prediction dates): $averageBasedPredictionDates');
    debugPrint(
        'Edit date screen (default period predictions): $defaultPeriodPredictions');

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                periodTrackerLegend(
                  ginaTheme,
                  isEditMode: true,
                ),
                const Gap(10),
                // --- Calendar List ---
                Expanded(
                  child: YearlyCalendarWidget(
                    periodDates: periodDates,
                    averageBasedPredictionDates: averageBasedPredictionDates,
                    day28PredictionDates: defaultPeriodPredictions,
                    isEditMode: true,
                    onPeriodDatesChanged: (newDates) {
                      setState(() {
                        periodDates = newDates;
                        debugPrint('Updated period dates: $periodDates');
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  cancelEditButton(periodTrackerBloc),
                  saveEditButton(periodTrackerBloc),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget cancelEditButton(PeriodTrackerBloc periodTrackerBloc) {
    return ElevatedButton(
      onPressed: () {
        periodTrackerBloc.add(GetFirstMenstrualPeriodDatesEvent());
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: GinaAppTheme.lightOnPrimaryColor,
        backgroundColor: GinaAppTheme.lightSurfaceVariant,
        shadowColor: GinaAppTheme.defaultBoxShadow.color,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        minimumSize: const Size(150, 40),
      ),
      child: const Text(
        'Cancel',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget saveEditButton(PeriodTrackerBloc periodTrackerBloc) {
    return ElevatedButton(
      onPressed: () {
        debugPrint('Save button pressed. Current period dates: $periodDates');
        if (periodDates.isEmpty) {
          debugPrint('No period dates selected.');
          return;
        }

        final sortedDates = periodDates..sort();
        final groupedDates = _groupDatesByRange(sortedDates);

        for (var dates in groupedDates) {
          periodTrackerBloc.add(LogFirstMenstrualPeriodEvent(
            periodDates: dates,
            startDate: dates.first,
            endDate: dates.last,
          ));

          debugPrint('Period Dates: $dates');
          debugPrint('Start Date: ${dates.first}');
          debugPrint('End Date: ${dates.last}');
        }
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: GinaAppTheme.lightTertiaryContainer,
        shadowColor: GinaAppTheme.defaultBoxShadow.color,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        minimumSize: const Size(150, 40),
      ),
      child: const Text(
        'Save',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  List<List<DateTime>> _groupDatesByRange(List<DateTime> dates) {
    List<List<DateTime>> groupedDates = [];
    List<DateTime> currentGroup = [];

    for (int i = 0; i < dates.length; i++) {
      if (currentGroup.isEmpty ||
          dates[i].difference(currentGroup.last).inDays <= 1) {
        currentGroup.add(dates[i]);
      } else {
        groupedDates.add(currentGroup);
        currentGroup = [dates[i]];
      }
    }

    if (currentGroup.isNotEmpty) {
      groupedDates.add(currentGroup);
    }

    return groupedDates;
  }
}
