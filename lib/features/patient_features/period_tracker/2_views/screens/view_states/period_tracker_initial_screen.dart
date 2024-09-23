import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/bloc/period_tracker_bloc.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/screens/widgets/period_tracker_legend.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/screens/widgets/yearly_calendar_widget.dart';

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
                SizedBox(
                  height: height * 0.8,
                  width: width * 0.9,
                  child: const YearlyCalendarWidget(),
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
    return GestureDetector(
      onTap: () {
        periodTrackerBloc.add(NavigateToPeriodTrackerEditDatesEvent());
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 60.0),
          child: Container(
            width: 150,
            height: 40,
            decoration: BoxDecoration(
              color: GinaAppTheme.lightTertiaryContainer,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                GinaAppTheme.defaultBoxShadow,
              ],
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
          ),
        ),
      ),
    );
  }
}
