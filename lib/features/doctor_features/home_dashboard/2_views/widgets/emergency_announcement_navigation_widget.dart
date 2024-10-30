import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:icons_plus/icons_plus.dart';

class EmergencyAnnouncementNavigationWidget extends StatelessWidget {
  const EmergencyAnnouncementNavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context);

    return Container(
      height: size.height * 0.14,
      width: size.width / 2.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: GinaAppTheme.gradientColors,
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        boxShadow: [
          GinaAppTheme.defaultBoxShadow,
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            Images.emergencyAnnouncementIcon,
            width: 60,
            height: 60,
          ),
          const Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Emergency\nAnnouncement',
                style: ginaTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Adjusted color for better visibility
                ),
              ),
              const Icon(
                Bootstrap.arrow_right_circle_fill,
                color: Colors.white, // Adjusted color for better visibility
              ),
            ],
          ),
        ],
      ),
    );
  }
}
