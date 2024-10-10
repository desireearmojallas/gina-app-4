import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:gina_app_4/core/theme/theme_service.dart';

class ProfileUpdateErrorStatus extends StatelessWidget {
  const ProfileUpdateErrorStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: GinaAppTheme.appbarColorLight,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 250,
        width: 200,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: GinaAppTheme.lightError,
              size: 50,
            ),
            const Gap(10),
            const Text(
              'Failed to update profile. Please try again.',
              textAlign: TextAlign.center,
            ),
            const Gap(10),
            SizedBox(
              height: 30,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
