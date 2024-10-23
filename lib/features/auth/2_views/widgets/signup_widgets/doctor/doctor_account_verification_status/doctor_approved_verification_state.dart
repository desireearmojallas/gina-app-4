import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/2_views/bloc/auth_bloc.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/gina_header.dart';
import 'package:lottie/lottie.dart';

class DoctorApprovedVerificationState extends StatelessWidget {
  const DoctorApprovedVerificationState({super.key});

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context);
    final authBloc = context.read<AuthBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Verification Status'),
      ),
      body: Center(
        child: Column(
          children: [
            const Gap(40),
            Lottie.asset(
              Images.approvedVerificationLottie,
              width: 350,
              height: 350,
            ),
            const Gap(60),
            Text(
              'Verified and Ready!',
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
                  const TextSpan(
                      text:
                          // TODO: Add the doctor's name here
                          'Congrats, Doc!\nYour doctor verification has been '),
                  TextSpan(
                    text: 'approved.',
                    style: ginaTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: GinaAppTheme.lightTertiaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(40),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Welcome to ',
                  style: ginaTheme.textTheme.titleMedium?.copyWith(
                    color: GinaAppTheme.lightOutline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(3),
                GinaHeader(
                  size: 24.0,
                ),
                const Gap(3),
                Text(
                  '🎉', // Celebration emoji
                  style: ginaTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Gap(40),
            FilledButton(
              onPressed: () {
                authBloc.add(
                  ChangeWaitingForApprovalEvent(),
                );
                Navigator.pushReplacementNamed(
                  context,
                  '/doctorBottomNavigation',
                );
              },
              child: const Text('Proceed to Doctor Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
