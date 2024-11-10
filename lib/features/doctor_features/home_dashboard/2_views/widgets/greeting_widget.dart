import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:icons_plus/icons_plus.dart';
import 'dart:math';

class GreetingWidget extends StatelessWidget {
  final String doctorName;
  const GreetingWidget({
    super.key,
    required this.doctorName,
  });

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
      "Good morning, doc! Ready to support wellness today?",
      "New day, new opportunities to empower your patients!",
      "Morning check-in: Helping patients feel their best is why you’re here!",
      "Start strong, doc! Here’s to a day of empathy and care.",
      "Good morning, doc! Let’s bring positivity and support to patients’ lives.",
      "Rise and shine, doc! Today’s about creating safe spaces for health discussions.",
      "Time to make a difference! Your patients trust in your expertise.",
      "Bright and early! Patients feel safe with your guidance.",
      "Another day to support balanced health journeys, doc!",
      "Good morning! You’re here to make patients feel understood and supported."
    ];

    final List<String> noonTexts = [
      "Midday check-in, doc. How are you doing so far?",
      "You’re halfway through! Let’s keep the positive energy going, doc.",
      "Pause for a moment. Your care means so much to patients today.",
      "Midday boost! Supporting patients through each health milestone.",
      "Remember, doc, hydration and self-care keep you strong for your patients!",
      "Doc, you’re making a real difference with each consultation.",
      "Lunch hour check-in: Empower patients to take charge of their health.",
      "Quick breather, doc? Your support helps patients trust their bodies.",
      "Halfway through, doc! You’re guiding patients on their health journey.",
      "Take a moment, doc. You’re a beacon of support and understanding."
    ];

    final List<String> afternoonTexts = [
      "Afternoon, doc! Keep up the amazing work.",
      "Almost through the day! Patients appreciate your care, doc.",
      "Keep going, doc! Your guidance is helping patients feel at ease.",
      "Afternoon energy! Let’s finish strong and supportive, doc.",
      "Your compassion makes a difference—thank you for all you do!",
      "Doc, you’re a source of comfort and trust for your patients.",
      "Afternoon check-in: Your impact grows with every patient you help.",
      "Almost at the finish line! Keep creating safe spaces, doc.",
      "Your work goes beyond the clinical—it’s empowering patients every day.",
      "Each patient you help feels more empowered. You’re doing great, doc!"
    ];

    final List<String> eveningTexts = [
      "Evening check-in: Reflect on the lives you’ve touched today, doc.",
      "Your day’s work has given patients the courage to trust their health.",
      "Take a moment to breathe, doc. You’ve supported many today.",
      "Another day wrapped! Patients are grateful for your care and empathy.",
      "Time to unwind, doc. Rest and recharge—you deserve it!",
      "Reflect on today, doc. Your efforts inspire hope and health.",
      "End of day: Your dedication has made a lasting impact.",
      "Time to relax, doc! Your work has left patients feeling understood.",
      "Evening vibes: your care today has truly helped others.",
      "Rest easy, doc. You’re a vital part of so many health journeys."
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
    final firstName = doctorName.split(' ')[0];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '${getGreeting()} $firstName',
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
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
