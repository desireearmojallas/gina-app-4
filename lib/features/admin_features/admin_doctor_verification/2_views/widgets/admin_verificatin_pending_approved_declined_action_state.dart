import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class AdminVerificationPendingApprovedDeclinedActionState
    extends StatelessWidget {
  const AdminVerificationPendingApprovedDeclinedActionState({super.key});

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          const Gap(15),
          const Text(
            'Doctor Verification',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () {},
            child: Text(
              'Pending',
              style: ginaTheme.labelMedium?.copyWith(
                color: GinaAppTheme.lightTertiaryContainer,
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.solid,
                decorationColor: GinaAppTheme.lightTertiaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Gap(20),
          InkWell(
            onTap: () {},
            child: Text(
              'Approved',
              style: ginaTheme.labelMedium?.copyWith(
                color: GinaAppTheme.lightOutline,
              ),
            ),
          ),
          const Gap(20),
          InkWell(
            onTap: () {},
            child: Text(
              'Declined',
              style: ginaTheme.labelMedium?.copyWith(
                color: GinaAppTheme.lightOutline,
              ),
            ),
          ),
          const Gap(20),
        ],
      ),
    );
  }
}
