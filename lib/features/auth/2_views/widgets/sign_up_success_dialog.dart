import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/2_views/widgets/signup_widgets/doctor/doctor_account_verification/doctor_verification_status.dart';
import 'package:icons_plus/icons_plus.dart';

Future<dynamic> signUpSuccessDialog(
  BuildContext context,
) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: GinaAppTheme.appbarColorLight,
      shadowColor: GinaAppTheme.appbarColorLight,
      surfaceTintColor: GinaAppTheme.appbarColorLight,
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              MingCute.check_circle_fill,
              color: Colors.green,
              size: 80,
            ),
            Text(
              'Signup Success',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const Gap(25),
            Text(
              'You\'re in! Just one final hurdle - verification - and you\'ll be rocking GINA like a champ!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: GinaAppTheme.lightOutline,
                  ),
            ),
            const Gap(20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: FilledButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const DoctorVerificationStatusScreen(),
                    ),
                  );
                },
                child: Text(
                  'Get verified',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
