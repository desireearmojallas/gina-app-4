import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:lottie/lottie.dart';

class DoctorWaitingForApprovalState extends StatelessWidget {
  const DoctorWaitingForApprovalState({super.key});

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Verification Status'),
      ),
      body: Center(
        child: Column(
          children: [
            const Gap(30),
            Lottie.asset(
              Images.waitingForApprovalLottie,
              width: 350,
              height: 350,
            ),
            const Gap(60),
            Text(
              'Hang in There, Doc!',
              style: ginaTheme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: GinaAppTheme.lightTertiaryContainer,
              ),
            ),
            const Gap(30),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: ginaTheme.textTheme.bodyMedium?.copyWith(
                  color: GinaAppTheme.lightOutline,
                ),
                children: [
                  const TextSpan(text: 'Your verification request is '),
                  TextSpan(
                    text: 'in progress',
                    style: ginaTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: GinaAppTheme.pendingTextColor,
                    ),
                  ),
                  const TextSpan(
                      text: '\nand should be approved within 24 hours.'),
                ],
              ),
            ),
            const Gap(80),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Go back, I\'ll try again later'),
            ),
          ],
        ),
      ),
    );
  }
}
