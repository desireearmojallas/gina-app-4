import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:lottie/lottie.dart';

class DoctorDeclinedVerificationState extends StatelessWidget {
  const DoctorDeclinedVerificationState({super.key});

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
            const Gap(50),
            Lottie.asset(
              Images.declinedVerificationLottie,
              width: 150,
              height: 150,
            ),
            const Gap(60),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Denied, ',
                    style: ginaTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: GinaAppTheme.declinedTextColor,
                    ),
                  ),
                  TextSpan(
                    text: 'But Not Defeated!',
                    style: ginaTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 175, 175, 175),
                    ),
                  ),
                ],
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
                  const TextSpan(text: 'Your verification didn’t go through. '),
                  TextSpan(
                    text: '\nReview the requirements and resubmit',
                    style: ginaTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 101, 99, 116),
                    ),
                  ),
                  const TextSpan(text: '\nwhen you’re ready.'),
                ],
              ),
            ),
            const Gap(80),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: TextField(
                readOnly: true,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Reason for Decline',
                  labelStyle: ginaTheme.textTheme.bodyMedium?.copyWith(
                    color: GinaAppTheme.lightOutline,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                controller: TextEditingController(
                  text:
                      'Your verification was declined because of missing documents. Please review the requirements and resubmit.',
                ),
              ),
            ),
            const Gap(60),
            FilledButton(
              onPressed: () {},
              child: const Text('Resubmit Verification'),
            ),
          ],
        ),
      ),
    );
  }
}
