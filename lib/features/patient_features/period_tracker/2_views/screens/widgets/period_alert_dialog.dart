import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/0_models/period_tracker_model.dart';
import 'package:gina_app_4/features/patient_features/period_tracker/2_views/bloc/period_tracker_bloc.dart';
import 'package:intl/intl.dart';

class PeriodAlertDialog {
  static void showPeriodAlertDialog(
    BuildContext context,
    DateTime startDate,
    PeriodTrackerBloc bloc,
    List<PeriodTrackerModel> periodTrackerModel,
  ) {
    final random = Random();
    final int daysUntilPeriod = startDate.difference(DateTime.now()).inDays;

    // Messages for each day before the period
    List<String> messages = [
      // 3 days before
      'Drink plenty of water today to stay hydrated!',
      'Make sure you’re getting enough rest before your period arrives.',
      'Consider taking a warm bath to relax your muscles.',
      'It’s the perfect time to start preparing your favorite comfort food.',
      'Your body’s preparing for the changes. Be kind to yourself.',

      // 2 days before
      'Stretching can help relieve tension before your period.',
      'Start tracking any changes in your mood or energy levels.',
      'Taking it easy today will help you feel better tomorrow.',
      'It’s a good day to hydrate and start winding down.',
      'Start organizing your self-care plan for the upcoming days.',

      // 1 day before
      'Treat yourself to something soothing today.',
      'Get your heating pad ready, you might need it soon.',
      'Take a moment to relax and center yourself before your period starts.',
      'Prepare for tomorrow’s flow with light activities today.',
      'You’re almost there! A little patience goes a long way.',

      // The day of the period
      'Your period has arrived. Take it easy today.',
      'Remember to take care of yourself, your body needs rest.',
      'Light stretching and relaxation exercises will help with cramps.',
      'Treat yourself to a cozy day; you deserve it.',
      'Your period is here, and it’s the perfect time to relax and recharge.',
    ];

    String message = '';
    String periodReminder = '';
    IconData periodIcon = Icons.today_rounded; // Default icon for reminder

    // Dynamically create the period reminder message based on daysUntilPeriod
    if (daysUntilPeriod == 3) {
      message = messages[random.nextInt(5)]; // Random message for 3 days before
      periodReminder = 'Your period is coming in 3 days!';
      periodIcon = Icons.access_time; // Example icon for '3 days before'
    } else if (daysUntilPeriod == 2) {
      message =
          messages[5 + random.nextInt(5)]; // Random message for 2 days before
      periodReminder = 'Your period is coming in 2 days!';
      periodIcon = Icons.access_alarm; // Icon for '2 days before'
    } else if (daysUntilPeriod == 1) {
      message =
          messages[10 + random.nextInt(5)]; // Random message for 1 day before
      periodReminder = 'Your period is coming in 1 day!';
      periodIcon = Icons.schedule; // Icon for '1 day before'
    } else if (daysUntilPeriod == 0) {
      message = messages[
          15 + random.nextInt(5)]; // Random message for the day of the period
      periodReminder = 'Your period has arrived today!';
      periodIcon = Icons.event; // Icon for 'day of the period'
    } else {
      periodReminder =
          'Your period is coming in ${daysUntilPeriod.abs()} days.';
    }

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            children: [
              Row(
                children: [
                  Icon(
                    periodIcon,
                    color: GinaAppTheme.lightTertiaryContainer,
                    size: 24,
                  ),
                  const SizedBox(
                      width: 10), // Space between icon and title text
                  SizedBox(
                    width: 200,
                    child: Flexible(
                      child: Text(
                        periodReminder, // Use periodReminder as the title
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: GinaAppTheme.lightTertiaryContainer,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          content: Text.rich(
            TextSpan(
              text: 'Your next period is expected to start on:\n',
              style: const TextStyle(
                fontSize: 14,
              ),
              children: [
                TextSpan(
                  text: '${DateFormat('MMMM dd, yyyy').format(startDate)}.\n\n',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, // Make the date bold
                    fontSize: 14,
                  ),
                ),
                TextSpan(
                  text: message,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            if (daysUntilPeriod != 0)
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: GinaAppTheme.lightTertiaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.check_rounded, color: Colors.white),
                label: const Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            if (daysUntilPeriod == 0) // Check if it's the day of the period
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  bloc.add(
                    NavigateToPeriodTrackerEditDatesEvent(
                      periodTrackerModel: periodTrackerModel,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: GinaAppTheme.lightTertiaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.edit_rounded, color: Colors.white),
                label: const Text(
                  'Edit Period',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
