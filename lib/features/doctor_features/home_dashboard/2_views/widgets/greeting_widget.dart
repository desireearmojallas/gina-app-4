import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:icons_plus/icons_plus.dart';
import 'dart:math';

class GreetingWidget extends StatelessWidget {
  const GreetingWidget({super.key});

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 0 && hour < 12) {
      return 'Good Morning, Dr.';
    } else if (hour == 12) {
      return 'Good Noon, Dr.';
    } else if (hour > 12 && hour < 18) {
      return 'Good Afternoon, Dr.';
    } else {
      return 'Good Evening, Dr.';
    }
  }

  IconData getIcon() {
    final hour = DateTime.now().hour;

    if (hour >= 0 && hour < 12) {
      return Icons.local_florist_rounded; // Morning icon
    } else if (hour == 12) {
      return Icons.wb_sunny; // Noon icon
    } else if (hour > 12 && hour < 18) {
      return MingCute.sun_cloudy_fill; // Afternoon icon
    } else {
      return MingCute.moon_stars_fill; // Evening icon
    }
  }

  String getWittyText() {
    final hour = DateTime.now().hour;
    final List<String> morningTexts = [
      "Welcome to your dashboard. Have you had your coffee, doc?",
      "Ready to save some lives, doc?",
      "Rise and shine! Let's make today great, doc.",
      "Good morning! Let's get started, doc.",
      "Hope you had a good night's sleep, doc!"
    ];
    final List<String> noonTexts = [
      "Time for a quick break, doc?",
      "Midday check-in. How's your day going, doc?",
      "Halfway through the day! Keep up the great work, doc.",
      "Don't forget to hydrate, doc!",
      "Lunch break soon, doc?"
    ];
    final List<String> afternoonTexts = [
      "Keep pushing through, doc.",
      "You're doing amazing, doc!",
      "Almost there! The day is almost over, doc.",
      "Afternoon vibes. Keep it up, doc!",
      "Stay focused and keep going, doc."
    ];
    final List<String> eveningTexts = [
      "Time to wind down, doc.",
      "How was your day, doc?",
      "Relax, you've earned it, doc.",
      "Evening check-in. How are you feeling, doc?",
      "Take some time to relax, doc."
    ];

    if (hour >= 0 && hour < 12) {
      return morningTexts[Random().nextInt(morningTexts.length)];
    } else if (hour == 12) {
      return noonTexts[Random().nextInt(noonTexts.length)];
    } else if (hour > 12 && hour < 18) {
      return afternoonTexts[Random().nextInt(afternoonTexts.length)];
    } else {
      return eveningTexts[Random().nextInt(eveningTexts.length)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              getGreeting(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(10),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: GinaAppTheme.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Icon(
                getIcon(),
                size: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const Gap(10),
        Text(
          getWittyText(),
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
