import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/bloc/period_tracker_bloc.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/screens/widgets/period_tracker_legend.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/screens/widgets/period_tracker_widgets/yearly_calendar_widget.dart';

class PeriodTrackerInitialScreen extends StatelessWidget {
  const PeriodTrackerInitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final periodTrackerBloc = context.read<PeriodTrackerBloc>();
    final ginaTheme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

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
                const Expanded(
                  child: YearlyCalendarWidget(),
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
            // periodTrackerBloc.add(NavigateToPeriodTrackerEditDatesEvent());
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
