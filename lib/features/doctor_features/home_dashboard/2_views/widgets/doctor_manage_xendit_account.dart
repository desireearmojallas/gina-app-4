import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/doctor_features/doctor_payment_feature/2_views/screens/doctor_payment_screen.dart';

class DoctorManageXenditAccount extends StatelessWidget {
  const DoctorManageXenditAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ginaTheme = Theme.of(context);

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DoctorPaymentFeatureProvider(),
          ),
        );
      },
      child: Container(
        height: size.height * 0.08,
        width: size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: GinaAppTheme.gradientColors,
            begin: Alignment.bottomRight,
            end: Alignment.topRight,
          ),
          boxShadow: [
            GinaAppTheme.defaultBoxShadow,
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
          ),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    Images.myPaymentAccountIcon,
                    width: 100,
                    height: 80,
                  ),
                ],
              ),
              const Gap(28),
              Text(
                'My Payment Account',
                style: ginaTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: GinaAppTheme.appbarColorLight,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
