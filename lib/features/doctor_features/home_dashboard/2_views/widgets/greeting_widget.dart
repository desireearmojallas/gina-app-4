import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:icons_plus/icons_plus.dart';

class GreetingWidget extends StatelessWidget {
  const GreetingWidget({super.key});

  String getGreeting() {
    final hour = DateTime.now().hour;
    final random = Random();

    List<String> titles = [
      'Doctor',
      'Doc',
      'Dr',
      'Doktor',
      'Doktora',
      'Dra',
      'Dok',
    ];

    List<String> morningGreetings = [
      'Magandang umaga, ${titles[random.nextInt(titles.length)]}!', // Tagalog
      'Maayong buntag, ${titles[random.nextInt(titles.length)]}!', // Cebuano
      'Marhay na aga, ${titles[random.nextInt(titles.length)]}!', // Bicolano
      'Naimbag a bigat, ${titles[random.nextInt(titles.length)]}!', // Ilocano
      'Maupay nga aga, ${titles[random.nextInt(titles.length)]}!', // Waray
    ];

    List<String> noonGreetings = [
      'Magandang tanghali, ${titles[random.nextInt(titles.length)]}!', // Tagalog
      'Maayong udto, ${titles[random.nextInt(titles.length)]}!', // Cebuano
      'Marhay na udto, ${titles[random.nextInt(titles.length)]}!', // Bicolano
      'Naimbag a malem, ${titles[random.nextInt(titles.length)]}!', // Ilocano
      'Maupay nga udto, ${titles[random.nextInt(titles.length)]}!', // Waray
    ];

    List<String> afternoonGreetings = [
      'Magandang hapon, ${titles[random.nextInt(titles.length)]}!', // Tagalog
      'Maayong hapon, ${titles[random.nextInt(titles.length)]}!', // Cebuano
      'Marhay na hapon, ${titles[random.nextInt(titles.length)]}!', // Bicolano
      'Naimbag a malem, ${titles[random.nextInt(titles.length)]}!', // Ilocano
      'Maupay nga hapon, ${titles[random.nextInt(titles.length)]}!', // Waray
    ];

    List<String> eveningGreetings = [
      'Magandang gabi, ${titles[random.nextInt(titles.length)]}!', // Tagalog
      'Maayong gabii, ${titles[random.nextInt(titles.length)]}!', // Cebuano
      'Marhay na banggi, ${titles[random.nextInt(titles.length)]}!', // Bicolano
      'Naimbag a rabii, ${titles[random.nextInt(titles.length)]}!', // Ilocano
      'Maupay nga gab-i, ${titles[random.nextInt(titles.length)]}!', // Waray
    ];

    if (hour >= 0 && hour < 12) {
      return morningGreetings[random.nextInt(morningGreetings.length)];
    } else if (hour == 12) {
      return noonGreetings[random.nextInt(noonGreetings.length)];
    } else if (hour > 12 && hour < 18) {
      return afternoonGreetings[random.nextInt(afternoonGreetings.length)];
    } else {
      return eveningGreetings[random.nextInt(eveningGreetings.length)];
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

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
