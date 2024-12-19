import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';

class ConsultationWaitingAppointmentScreen extends StatelessWidget {
  const ConsultationWaitingAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(Images.waitingConsultationIllustration),
        Center(child: Text('Waiting for the appointment')),
        Gap(150),
      ],
    );
  }
}
