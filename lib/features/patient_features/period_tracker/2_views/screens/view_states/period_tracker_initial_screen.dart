/* import 'package:flutter/material.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/gina_patient_app_bar/gina_patient_app_bar.dart';
import 'package:menstrual_cycle_widget/menstrual_cycle_widget.dart';

class PeriodTrackerInitialScreen extends StatelessWidget {
  const PeriodTrackerInitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final instance = MenstrualCycleWidget.instance!;

    // Updating the widget configuration as needed
    instance.updateConfiguration(
      cycleLength: 28, // Set cycle length
      periodDuration: 5, // Set period duration
      userId: "1", // Set customer ID
    );

    return Scaffold(
      appBar: GinaPatientAppBar(
        title: 'Period Tracker',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Added padding for better spacing
        child: MenstrualCycleCalenderView(
          themeColor: "000000", // Theme color in hex (black)
          daySelectedColor: Colors.blue, // Color for the selected day
          logPeriodText: "Log Period", // Text for the button
          backgroundColorCode: "FFFFFF", // Background color in hex (white)
          hideInfoView: false, // Show the info view
          onDateSelected: (date) {
            // Handle date selection (optional)
            print("Selected date: $date");
          },
          onDataChanged: (value) {
            // Handle data change (optional)
            print("Data changed: $value");
          },
          hideBottomBar: false, // Display bottom bar
          hideLogPeriodButton: false, // Display "Log Period" button
          isExpanded: true, // Expanded view for better visibility
        ),
      ),
    );
  }
}
 */

import 'package:flutter/material.dart';
import 'package:gina_app_4/core/reusable_widgets/patient_reusable_widgets/gina_patient_app_bar/gina_patient_app_bar.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/screens/widgets/period_tracker_widget.dart';

class PeriodTrackerInitialScreen extends StatelessWidget {
  const PeriodTrackerInitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GinaPatientAppBar(
        title: 'Period Tracker',
      ),
      body: PeriodTrackerWidget(
        periodDays: [
          DateTime(2024, 9, 1),
          DateTime(2024, 9, 2)
        ], // Example period days
        onDayTapped: (date) {
          showEditPeriodDialog(context, date);
        },
      ),
    );
  }
}
