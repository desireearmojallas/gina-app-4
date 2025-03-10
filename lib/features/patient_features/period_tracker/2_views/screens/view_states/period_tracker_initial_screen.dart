import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/bloc/period_tracker_bloc.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/screens/widgets/period_tracker_legend.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/screens/widgets/period_tracker_widgets/yearly_calendar_widget.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PeriodTrackerInitialScreen extends StatelessWidget {
  final List<PeriodTrackerModel> periodTrackerModel;
  final List<PeriodTrackerModel> allPeriodsWithPredictions;
  PeriodTrackerInitialScreen({
    super.key,
    required this.periodTrackerModel,
    required this.allPeriodsWithPredictions,
  });

  final dateRange = DateRangePickerController();
  final periodDateRange = DateRangePickerController();
  final defaultPeriodDateRange = DateRangePickerController();

  @override
  Widget build(BuildContext context) {
    final periodTrackerBloc = context.read<PeriodTrackerBloc>();
    final ginaTheme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // Extract period dates from allPeriodsWithPredictions
    final periodDates =
        allPeriodsWithPredictions.expand((p) => p.periodDates).toList();

    // Extract average-based prediction dates
    final averageBasedPredictionDates = allPeriodsWithPredictions
        .expand((p) => p.averageBasedPredictionDates)
        .toList();

    // Extract 28-day cycle prediction dates
    final defaultPeriodPredictions = allPeriodsWithPredictions
        .where((p) => p.cycleLength == 28)
        .expand((p) => p.day28PredictionDates)
        .toList();

    // Debug print statements
    debugPrint('Period Dates: $periodDates');
    debugPrint('Average Based Prediction Dates: $averageBasedPredictionDates');
    debugPrint('Default Period Predictions: $defaultPeriodPredictions');

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                periodTrackerLegend(ginaTheme),
                const Gap(10),
                // --- Calendar List ---
                Expanded(
                  child: YearlyCalendarWidget(
                    periodDates: periodDates,
                    averageBasedPredictionDates: averageBasedPredictionDates,
                    day28PredictionDates: defaultPeriodPredictions,
                    isEditMode: false,
                    onPeriodDatesChanged: (newDates) {
                      // Update the period dates when they change
                      periodDates.clear();
                      periodDates.addAll(newDates);
                    },
                  ),
                ),
              ],
            ),
          ),
          editPeriodDatesButton(ginaTheme, context, periodTrackerBloc),
        ],
      ),
    );
  }

  Widget editPeriodDatesButton(
      ThemeData ginaTheme, BuildContext context, Bloc periodTrackerBloc) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: ElevatedButton(
          onPressed: () {
            periodTrackerBloc.add(NavigateToPeriodTrackerEditDatesEvent(
              periodTrackerModel: allPeriodsWithPredictions,
            ));
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: GinaAppTheme.lightTertiaryContainer,
            shadowColor: GinaAppTheme.defaultBoxShadow.color,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            minimumSize: const Size(150, 40),
          ),
          child: Text(
            'Edit Period Dates',
            style: ginaTheme.textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
