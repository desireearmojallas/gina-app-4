import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';
import 'package:gina_app_4/features/auth/0_model/doctor_model.dart';
import 'package:gina_app_4/features/doctor_features/doctor_consultation_fee/2_views/widgets/doctor_name_widget.dart';

class ConsultationFeeNoPricingScreen extends StatelessWidget {
  final DoctorModel doctor;
  const ConsultationFeeNoPricingScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final ginaTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        doctorNameWidget(size, ginaTheme, doctor),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 15.0),
          child: Column(
            children: [
              Image.asset(
                Images.hiddenConsultationFeeIllustration,
                width: size.width * 0.65,
              ),
              const Gap(20),
              Text(
                'Unfortunately,',
                style: ginaTheme.headlineSmall,
              ),
              Text(
                'the doctor\'s pricing information is not available',
                style: ginaTheme.titleMedium,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 35.0),
                child: Text(
                  'We understand the importance of price transparency and encourage you to ask the doctor about their fees during your consultation.',
                  textAlign: TextAlign.center,
                  style: ginaTheme.bodySmall?.copyWith(
                    color: GinaAppTheme.lightOutline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
