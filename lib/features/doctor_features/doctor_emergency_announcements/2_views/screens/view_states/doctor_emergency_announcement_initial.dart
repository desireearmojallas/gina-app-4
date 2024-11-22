import 'package:flutter/material.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class DoctorEmergencyAnnouncementInitialScreen extends StatelessWidget {
  const DoctorEmergencyAnnouncementInitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 80.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Images.emergencyAnnouncementIllustration,
          ),
          Text(
            'No emergency announcement.',
            style: ginaTheme.headlineSmall,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 35.0),
            child: Text(
              'If you need to reschedule due to an urgent matter, please notify your patients here.',
              textAlign: TextAlign.center,
              style: ginaTheme.bodySmall?.copyWith(
                color: GinaAppTheme.lightOutline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
