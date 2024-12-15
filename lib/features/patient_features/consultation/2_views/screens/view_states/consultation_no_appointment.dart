import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class ConsultationNoAppointmentScreen extends StatelessWidget {
  const ConsultationNoAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(Images.noConsultationIllustration),
        const Gap(30),
        const Text(
          'No appointment found',
          style: TextStyle(
            color: GinaAppTheme.lightOutline,
          ),
        ),
        const Gap(80),
      ],
    );
  }
}
