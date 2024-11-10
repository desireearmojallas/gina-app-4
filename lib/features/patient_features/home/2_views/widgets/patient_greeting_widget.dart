import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:icons_plus/icons_plus.dart';
import 'dart:math';

class PatientGreetingWidget extends StatelessWidget {
  final String patientName;
  const PatientGreetingWidget({
    super.key,
    required this.patientName,
  });

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 0 && hour < 12) {
      return 'Good Morning,';
    } else if (hour == 12) {
      return 'Good Noon,';
    } else if (hour > 12 && hour < 18) {
      return 'Good Afternoon,';
    } else {
      return 'Good Evening,';
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
    "Good morning! Check in with your cycle and start the day gently.",
    "New day, new focus. Stay mindful of what your body needs today!",
    "Morning boost: track any symptoms and set intentions for self-care.",
    "Rise and shine! Let’s start the day feeling balanced and in tune.",
    "Start the day with love for yourself and respect for your body.",
    "Good morning! Remember, your cycle can guide you through the day.",
    "Today’s a fresh start—listen to your body’s rhythm.",
    "Your wellness matters! Take time to note how you’re feeling today.",
    "Morning check-in: be gentle with yourself and honor where you are.",
    "A new day to nurture yourself. Your health is a top priority!"
  ];

  final List<String> noonTexts = [
    "Midday check-in! Hydrate and take a moment for self-care.",
    "It’s noon—how are you feeling? Your body’s signals are important!",
    "Halfway through the day! Take a moment to tune in with yourself.",
    "Midday reminder: honor your cycle and take things at your pace.",
    "Hope your day’s going smoothly. Acknowledge any cycle changes.",
    "Halfway there! Stay aware of your energy and rest if needed.",
    "Remember to pause, breathe, and check in with how you’re feeling.",
    "A gentle reminder to keep your self-care strong.",
    "Stay in tune with your cycle—it can guide your energy levels.",
    "Midday self-care: a moment for you and your well-being."
  ];

  final List<String> afternoonTexts = [
    "Afternoon check-in! Taking a moment to listen to your body?",
    "Almost done with the day! Honor your energy and mood.",
    "Feeling balanced? Take note, and adjust for self-care as needed.",
    "Stay strong and mindful—your well-being comes first.",
    "Heading toward evening? Check in on your cycle and relax.",
    "Afternoon vibes: pay attention to how you feel and what you need.",
    "Stay centered and in tune with your body’s natural rhythms.",
    "Your energy matters! Take a break if you need it.",
    "Remember, it’s okay to take it easy—especially during certain phases.",
    "Almost there! Keep self-care in mind for the rest of your day."
  ];

  final List<String> eveningTexts = [
    "Evening check-in! How’s your energy after today?",
    "Reflect on how you’re feeling as the day winds down.",
    "Take it easy tonight—your body deserves a gentle evening.",
    "You’ve done so much today. Relax and give yourself a break.",
    "Wind down with self-care. Take note of any cycle changes.",
    "Evening is the perfect time to reflect on your wellness today.",
    "How are you feeling tonight? Honor your body’s needs.",
    "Let go of the day’s stress—rest and recharge for tomorrow.",
    "Nurture yourself tonight. Your health journey is ongoing.",
    "You did well today! Take time for a calming night routine."
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
    final firstName = patientName.split(' ')[0];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '${getGreeting()} $firstName!',
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
