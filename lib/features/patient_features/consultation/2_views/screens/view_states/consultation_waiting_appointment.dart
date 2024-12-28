import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ConsultationWaitingAppointmentScreen extends StatelessWidget {
  const ConsultationWaitingAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Center(child: Image.asset(Images.consultationWaitingAppointment)),
        Center(
          child: Text('Waiting for appointment'),
        ),
        Gap(150),
      ],
    );
  }
}
