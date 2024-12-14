import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ConsultationWaitingAppointmentScreen extends StatelessWidget {
  const ConsultationWaitingAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: Text('Waiting for the appointment')),
        Gap(150),
      ],
    );
  }
}
