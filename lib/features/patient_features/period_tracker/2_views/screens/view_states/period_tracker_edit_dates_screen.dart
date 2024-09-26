import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/screens/widgets/period_tracker_legend.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/screens/widgets/yearly_calendar_widget.dart';

class PeriodTrackerEditDatesScreen extends StatelessWidget {
  const PeriodTrackerEditDatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            periodTrackerLegend(ginaTheme),
            const Gap(10),
            // --- Calendar List ---
            SizedBox(
              height: height * 0.8,
              width: width * 0.9,
              child: const YearlyCalendarWidget(
                isEditMode: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
