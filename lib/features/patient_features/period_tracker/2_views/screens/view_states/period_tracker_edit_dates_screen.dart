import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/screens/widgets/period_tracker_legend.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/screens/widgets/period_tracker_widgets/yearly_calendar_widget.dart';

class PeriodTrackerEditDatesScreen extends StatelessWidget {
  const PeriodTrackerEditDatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context);

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
                const Expanded(
                  child: YearlyCalendarWidget(
                    isEditMode: true,
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
                  cancelEditButton(context),
                  saveEditButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget cancelEditButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
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

  Widget saveEditButton() {
    return ElevatedButton(
      onPressed: () {},
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
}
