import 'package:flutter/material.dart';
import 'package:gina_app_4/core/resources/images.dart';

class EmergencyAnnouncementEmptyState extends StatelessWidget {
  const EmergencyAnnouncementEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        Image.asset(
          Images.emergencyAnnouncementIllustration,
        ),
        const Text(
          'No emergency announcement available',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
